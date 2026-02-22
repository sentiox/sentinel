include $(TOPDIR)/rules.mk

PKG_NAME:=sentinel

PKG_VERSION := $(if $(SENTINEL_VERSION),$(SENTINEL_VERSION),0.$(shell date +%d%m%Y))

PKG_RELEASE:=1

PKG_MAINTAINER:=Sentiox
PKG_LICENSE:=GPL-2.0-or-later

include $(INCLUDE_DIR)/package.mk

define Package/sentinel
	SECTION:=net
	CATEGORY:=Network
	DEPENDS:=+curl +jq +kmod-nft-tproxy +coreutils-base64 +bind-dig
	CONFLICTS:=https-dns-proxy nextdns luci-app-passwall luci-app-passwall2
	TITLE:=Domain routing app
	URL:=https://podkop.net
	PKGARCH:=all
endef

define Package/sentinel/description
	Domain routing. Use of VLESS, Shadowsocks technologies
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

	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/etc/config/sentinel $(1)/etc/config/sentinel

	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) ./files/usr/bin/sentinel $(1)/usr/bin/sentinel

	$(INSTALL_DIR) $(1)/usr/lib/sentinel
	$(CP) ./files/usr/lib/* $(1)/usr/lib/sentinel/

	sed -i -e 's/__COMPILED_VERSION_VARIABLE__/$(PKG_VERSION)/g' $(1)/usr/lib/sentinel/constants.sh
endef

$(eval $(call BuildPackage,sentinel))
