#!/bin/sh

REPO="https://api.github.com/repos/sentiox/sentinel/releases/latest"
DOWNLOAD_DIR="/tmp/sentinel"
COUNT=3

rm -rf "$DOWNLOAD_DIR"
mkdir -p "$DOWNLOAD_DIR"

msg() {
    printf "\033[32;1m%s\033[0m\n" "$1"
}

main() {
    check_system
    sing_box

    /usr/sbin/ntpd -q -p 194.190.168.1 -p 216.239.35.0 -p 216.239.35.4 -p 162.159.200.1 -p 162.159.200.123

    opkg update || { echo "opkg update failed"; exit 1; }

    if [ -f "/etc/init.d/sentinel" ]; then
        msg "Sentinel is already installed. Upgrading..."
    else
        msg "Installing Sentinel..."
    fi

    if command -v curl >/dev/null 2>&1; then
        check_response=$(curl -s "$REPO")
        if echo "$check_response" | grep -q 'API rate limit'; then
            msg "GitHub API rate limit reached. Try again later."
            exit 1
        fi
    fi

    download_success=0
    while read -r url; do
        filename=$(basename "$url")
        filepath="$DOWNLOAD_DIR/$filename"

        attempt=0
        while [ $attempt -lt $COUNT ]; do
            msg "Downloading $filename (attempt $((attempt+1)))..."
            if wget -q -O "$filepath" "$url"; then
                if [ -s "$filepath" ]; then
                    msg "$filename downloaded successfully"
                    download_success=1
                    break
                fi
            fi
            msg "Download error. Retrying..."
            rm -f "$filepath"
            attempt=$((attempt+1))
        done

        if [ $attempt -eq $COUNT ]; then
            msg "Failed to download $filename"
        fi
    done < <(wget -qO- "$REPO" | grep -o 'https://[^"[:space:]]*\.ipk')

    if [ $download_success -eq 0 ]; then
        msg "No packages downloaded"
        exit 1
    fi

    for pkg in sentinel luci-app-sentinel; do
        file=$(ls "$DOWNLOAD_DIR" | grep "^$pkg" | head -n 1)
        if [ -n "$file" ]; then
            msg "Installing $file"
            opkg install "$DOWNLOAD_DIR/$file"
            sleep 3
        fi
    done

    ru=$(ls "$DOWNLOAD_DIR" | grep "luci-i18n-sentinel-ru" | head -n 1)
    if [ -n "$ru" ]; then
        if opkg list-installed | grep -q luci-i18n-sentinel-ru; then
            msg "Upgrading Russian translation..."
            opkg remove luci-i18n-sentinel*
            opkg install "$DOWNLOAD_DIR/$ru"
        else
            msg "Install Russian language support? (y/n)"
            while true; do
                read -r RUS
                case $RUS in
                    y|Y)
                        opkg remove luci-i18n-sentinel*
                        opkg install "$DOWNLOAD_DIR/$ru"
                        break
                        ;;
                    n|N)
                        break
                        ;;
                    *)
                        echo "Please enter y or n"
                        ;;
                esac
            done
        fi
    fi

    find "$DOWNLOAD_DIR" -type f -name '*sentinel*' -exec rm {} \;
}

check_system() {
    MODEL=$(cat /tmp/sysinfo/model)
    msg "Router model: $MODEL"

    openwrt_version=$(grep DISTRIB_RELEASE /etc/openwrt_release | cut -d"'" -f2 | cut -d'.' -f1)
    if [ "$openwrt_version" = "23" ]; then
        msg "OpenWrt 23.05 is not supported"
        exit 1
    fi

    AVAILABLE_SPACE=$(df /overlay | awk 'NR==2 {print $4}')
    REQUIRED_SPACE=15360

    if [ "$AVAILABLE_SPACE" -lt "$REQUIRED_SPACE" ]; then
        msg "Insufficient flash space"
        exit 1
    fi

    if ! nslookup google.com >/dev/null 2>&1; then
        msg "DNS not working"
        exit 1
    fi

    if opkg list-installed | grep -q https-dns-proxy; then
        msg "Conflicting package detected: https-dns-proxy. Remove? (y/n)"
        read -r DNSPROXY
        case $DNSPROXY in
            y|Y)
                opkg remove --force-depends luci-app-https-dns-proxy https-dns-proxy luci-i18n-https-dns-proxy*
                ;;
            *)
                msg "Exit"
                exit 1
                ;;
        esac
    fi
}

sing_box() {
    if ! opkg list-installed | grep -q "^sing-box"; then
        return
    fi

    sing_box_version=$(sing-box version | head -n 1 | awk '{print $3}')
    required_version="1.12.4"

    if [ "$(printf "%s\n%s\n" "$required_version" "$sing_box_version" | sort -V | head -n1)" != "$required_version" ]; then
        msg "Outdated sing-box detected, removing..."
        service sentinel stop
        opkg remove sing-box --force-depends
    fi
}

main
