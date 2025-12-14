include $(TOPDIR)/rules.mk

PKG_NAME:=sentinel

PKG_VERSION:=$(if $(PKG_VERSION),$(PKG_VERSION),dev_$(shell date +%d%m%Y))
PKG_RELEASE:=1

PKG_MAINTAINER:=Sentinel Project <support@sentinel.local>
PKG_LICENSE:=GPL-2.0-or-later

include $(INCLUDE_DIR)/package.mk

define Package/sentinel
	SECTION:=net
	CATEGORY:=Network
#	DEPENDS:=+sing-box +curl +jq +kmod-nft-tproxy +coreutils-base64
	CONFLICTS:=https-dns-proxy nextdns luci-app-passwall luci-app-passwall2
	TITLE:=Sentinel domain routing service
	URL:=https://github.com/sentiox/sentinel
	PKGARCH:=all
endef

define Package/sentinel/description
	Domain routing service. Supports VLESS and Shadowsocks technologies.
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/sentinel/prerm
#!/bin/sh

grep -q "105 sentinel" /etc/iproute2/rt_tables && sed -i "/105 sentinel/d" /etc/iproute2/rt_tables

/etc/init.d/sentinel stop

exit 0
endef

define Package/sentinel/conffiles
/etc/config/sentinel
endef

define Package/sentinel/install
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/etc/init.d/sentinel $(1)/etc/init.d/sentinel
	sed -i "s/VERSION_FROM_MAKEFILE/$(PKG_VERSION)/g" $(1)/etc/init.d/sentinel

	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/etc/config/sentinel $(1)/etc/config/sentinel

	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) ./files/usr/bin/sentinel $(1)/usr/bin/sentinel

	$(INSTALL_DIR) $(1)/usr/lib/sentinel
	$(CP) ./files/usr/lib/* $(1)/usr/lib/sentinel/
endef

$(eval $(call BuildPackage,sentinel))
