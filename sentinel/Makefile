include $(TOPDIR)/rules.mk

PKG_NAME:=sentinel
PKG_VERSION:=1.0
PKG_RELEASE:=1
PKGARCH:=all

PKG_LICENSE:=GPL-2.0-or-later
PKG_MAINTAINER:=Mizoil <mizoil@users.noreply.github.com>

include $(INCLUDE_DIR)/package.mk

define Package/sentinel
	SECTION:=net
	CATEGORY:=Network
	TITLE:=Domain routing app
	URL:=https://sentinel.net
	DEPENDS:=+sing-box +curl +jq +kmod-nft-tproxy +coreutils-base64
	CONFLICTS:=https-dns-proxy nextdns luci-app-passwall luci-app-passwall2
endef

define Package/sentinel/description
Domain routing. Use of VLESS, Shadowsocks technologies
endef

# ⛔ НЕТ Build/Configure
# ⛔ НЕТ Build/Compile

define Package/sentinel/prerm
#!/bin/sh

grep -q "105 sentinel" /etc/iproute2/rt_tables && \
	sed -i "/105 sentinel/d" /etc/iproute2/rt_tables

/etc/init.d/sentinel stop

exit 0
endef

define Package/sentinel/conffiles
/etc/config/sentinel
endef

define Package/sentinel/install
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/etc/init.d/sentinel $(1)/etc/init.d/sentinel

	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/etc/config/sentinel $(1)/etc/config/sentinel

	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) ./files/usr/bin/sentinel $(1)/usr/bin/sentinel

	$(INSTALL_DIR) $(1)/usr/lib/sentinel
	$(CP) ./files/usr/lib/* $(1)/usr/lib/sentinel/
endef

$(eval $(call BuildPackage,sentinel))
