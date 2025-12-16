#!/bin/sh
# shellcheck disable=SC2034

# =========================
# Table / Sets
# =========================

nft_create_table() {
    local name="$1"
    nft add table inet "$name" 2>/dev/null
}

nft_create_ipv4_set() {
    local table="$1"
    local name="$2"

    nft add set inet "$table" "$name" \
        '{ type ipv4_addr; flags interval; auto-merge; }' 2>/dev/null
}

nft_create_ifname_set() {
    local table="$1"
    local name="$2"

    nft add set inet "$table" "$name" \
        '{ type ifname; flags interval; }' 2>/dev/null
}

nft_add_set_elements() {
    local table="$1"
    local set="$2"
    local elements="$3"

    [ -z "$elements" ] && return 0
    nft add element inet "$table" "$set" "{ $elements }" 2>/dev/null
}

# Chains

nft_create_mangle_chain() {
    local table="$1"

    nft add chain inet "$table" mangle \
        '{ type filter hook prerouting priority mangle; policy accept; }' 2>/dev/null
}

nft_create_mangle_output_chain() {
    local table="$1"

    nft add chain inet "$table" mangle_output \
        '{ type route hook output priority mangle; policy accept; }' 2>/dev/null
}

nft_create_proxy_chain() {
    local table="$1"

    nft add chain inet "$table" proxy \
        '{ type filter hook prerouting priority dstnat; policy accept; }' 2>/dev/null
}

# Common subnets (DEFAULT)

nft_add_common_subnet_rules() {
    local table="$1"

    # TCP
    nft add rule inet "$table" mangle \
        iifname "@$NFT_INTERFACE_SET_NAME" \
        ip daddr "@$NFT_COMMON_SET_NAME" \
        meta l4proto tcp meta mark set 0x105 counter 2>/dev/null

    # UDP
    nft add rule inet "$table" mangle \
        iifname "@$NFT_INTERFACE_SET_NAME" \
        ip daddr "@$NFT_COMMON_SET_NAME" \
        meta l4proto udp meta mark set 0x105 counter 2>/dev/null
}

# Roblox (FIXED)

nft_add_roblox_rules() {
    local table="$1"

    nft_create_ipv4_set "$table" "$NFT_ROBLOX_SET_NAME"

    # TCP (launcher / auth)
    nft add rule inet "$table" mangle \
        iifname "@$NFT_INTERFACE_SET_NAME" \
        ip daddr "@$NFT_ROBLOX_SET_NAME" \
        meta l4proto tcp meta mark set 0x105 counter 2>/dev/null

    # UDP (GAMEPLAY — КРИТИЧНО)
    nft add rule inet "$table" mangle \
        iifname "@$NFT_INTERFACE_SET_NAME" \
        ip daddr "@$NFT_ROBLOX_SET_NAME" \
        meta l4proto udp meta mark set 0x105 counter 2>/dev/null
}

# Discord 

nft_add_discord_rules() {
    local table="$1"

    nft_create_ipv4_set "$table" "$NFT_DISCORD_SET_NAME"

    nft add rule inet "$table" mangle \
        iifname "@$NFT_INTERFACE_SET_NAME" \
        ip daddr "@$NFT_DISCORD_SET_NAME" \
        udp dport '{ 50000-65535 }' \
        meta mark set 0x105 counter 2>/dev/null
}
