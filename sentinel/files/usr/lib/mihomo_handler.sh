#!/bin/sh
# shellcheck disable=SC2154

# Mihomo (Clash.Meta) subscription handler for Sentinel OpenWrt
# Runs Mihomo on the same tproxy port (1602) as sing-box,
# so existing NFtables rules work without changes.

MIHOMO_CONFIG_DIR="/tmp/mihomo"
MIHOMO_CONFIG_FILE="$MIHOMO_CONFIG_DIR/config.yaml"
MIHOMO_PID_FILE="/var/run/mihomo.pid"
MIHOMO_LOG_FILE="/tmp/mihomo.log"

# Detect if content is a Mihomo/Clash YAML config
# Returns 0 (true) if it looks like Mihomo YAML, 1 otherwise
is_mihomo_yaml() {
    local file="$1"
    grep -qE "^proxies:|^proxy-groups:|^rules:|^rule-providers:" "$file" 2>/dev/null
}

# Prepare Mihomo YAML config for OpenWrt transparent proxy:
#   - Sets tproxy-port to SB_TPROXY_INBOUND_PORT (1602) to match existing NFtables rules
#   - Changes DNS listen to SB_DNS_INBOUND_ADDRESS:SB_DNS_INBOUND_PORT (127.0.0.42:53)
#   - Disables TUN mode (not needed with tproxy)
#   - Removes PROCESS-NAME rules (not supported on OpenWrt)
#   - Removes process detection settings
mihomo_prepare_config() {
    local input_file="$1"

    mkdir -p "$MIHOMO_CONFIG_DIR"
    mkdir -p "$MIHOMO_CONFIG_DIR/rule-sets"

    local tmpout
    tmpout=$(mktemp)

    # Process config with awk:
    # 1. Disable TUN (set enable: false, strict-route: false)
    # 2. Remove PROCESS-NAME rules
    # 3. Remove process detection settings
    awk '
        /^tun:/ { in_tun = 1; print; next }
        in_tun && /^  enable:/ { print "  enable: false"; next }
        in_tun && /^  strict-route:/ { print "  strict-route: false"; next }
        in_tun && /^  auto-route:/ { print "  auto-route: false"; next }
        in_tun && /^  auto-detect-interface:/ { print "  auto-detect-interface: false"; next }
        /^[a-z]/ { in_tun = 0 }
        /^find-process-mode:/ { print "find-process-mode: off"; next }
        /^enable-process:/ { next }
        /PROCESS-NAME/ { next }
        { print }
    ' "$input_file" > "$tmpout"

    # Set tproxy-port to match sentinel NFtables rules (port 1602)
    if grep -q "^tproxy-port:" "$tmpout"; then
        sed -i "s/^tproxy-port:.*/tproxy-port: $SB_TPROXY_INBOUND_PORT/" "$tmpout"
    else
        sed -i "1a tproxy-port: $SB_TPROXY_INBOUND_PORT" "$tmpout"
    fi

    # Set DNS listen address to match sentinel's DNS inbound (127.0.0.42:53)
    # This lets dnsmasq continue pointing to 127.0.0.42 for DNS
    if grep -q "^  listen:" "$tmpout"; then
        sed -i "s|^  listen:.*|  listen: $SB_DNS_INBOUND_ADDRESS:$SB_DNS_INBOUND_PORT|" "$tmpout"
    fi

    # Ensure allow-lan is true (needed for router transparent proxy)
    if grep -q "^allow-lan:" "$tmpout"; then
        sed -i "s/^allow-lan:.*/allow-lan: true/" "$tmpout"
    else
        sed -i "1a allow-lan: true" "$tmpout"
    fi

    cp "$tmpout" "$MIHOMO_CONFIG_FILE"
    rm -f "$tmpout"

    local line_count
    line_count=$(wc -l < "$MIHOMO_CONFIG_FILE")
    log "Mihomo config prepared: $line_count lines, tproxy on port $SB_TPROXY_INBOUND_PORT, DNS on $SB_DNS_INBOUND_ADDRESS:$SB_DNS_INBOUND_PORT"
    return 0
}

# Start Mihomo process
mihomo_start() {
    if ! command -v mihomo >/dev/null 2>&1; then
        log "mihomo binary not found. Install: opkg update && opkg install mihomo" "fatal"
        return 1
    fi

    if [ ! -f "$MIHOMO_CONFIG_FILE" ]; then
        log "Mihomo config not found at $MIHOMO_CONFIG_FILE" "fatal"
        return 1
    fi

    mihomo_stop

    mihomo -d "$MIHOMO_CONFIG_DIR" > "$MIHOMO_LOG_FILE" 2>&1 &
    local pid=$!
    echo "$pid" > "$MIHOMO_PID_FILE"

    sleep 1
    if kill -0 "$pid" 2>/dev/null; then
        log "Mihomo started (PID: $pid)"
        return 0
    else
        log "Mihomo failed to start, check $MIHOMO_LOG_FILE" "fatal"
        rm -f "$MIHOMO_PID_FILE"
        return 1
    fi
}

# Stop Mihomo process
mihomo_stop() {
    if [ -f "$MIHOMO_PID_FILE" ]; then
        local pid
        pid=$(cat "$MIHOMO_PID_FILE")
        if kill -0 "$pid" 2>/dev/null; then
            kill "$pid"
            log "Mihomo stopped (PID: $pid)"
        fi
        rm -f "$MIHOMO_PID_FILE"
    fi
    # Fallback: kill any remaining mihomo processes
    killall mihomo 2>/dev/null || true
}

# Check if Mihomo is running
mihomo_is_running() {
    [ -f "$MIHOMO_PID_FILE" ] && kill -0 "$(cat "$MIHOMO_PID_FILE")" 2>/dev/null
}

# Full Mihomo subscription init:
# Downloads the subscription URL, detects if it's Mihomo YAML,
# prepares the config and starts Mihomo.
# Returns 0 on success, 1 if not a Mihomo subscription (fall back to sing-box).
mihomo_init_from_subscription() {
    local section="$1"

    local subscription_url
    config_get subscription_url "$section" "subscription_url"

    if [ -z "$subscription_url" ]; then
        return 1
    fi

    local tmpfile
    tmpfile=$(mktemp)

    local sentinel_ua sentinel_hwid sentinel_model sentinel_os_ver
    sentinel_ua="$(get_sentinel_user_agent)"
    sentinel_hwid="$(get_device_hwid)"
    sentinel_model="$(get_device_model)"
    sentinel_os_ver="$(cat /etc/openwrt_release 2>/dev/null | grep DISTRIB_RELEASE | cut -d'=' -f2 | tr -d "'")"

    log "Mihomo: downloading subscription from $subscription_url"
    download_to_file "$subscription_url" "$tmpfile" "" 3 2 "$sentinel_ua" "$sentinel_hwid" "$sentinel_model" "$sentinel_os_ver"

    if [ ! -s "$tmpfile" ]; then
        log "Mihomo: failed to download subscription" "error"
        rm -f "$tmpfile"
        return 1
    fi

    convert_crlf_to_lf "$tmpfile"

    if ! is_mihomo_yaml "$tmpfile"; then
        log "Mihomo: subscription is not YAML format, falling back to sing-box" "debug"
        rm -f "$tmpfile"
        return 1
    fi

    log "Mihomo: detected Mihomo/Clash YAML subscription"
    mihomo_prepare_config "$tmpfile"
    rm -f "$tmpfile"
    return 0
}
