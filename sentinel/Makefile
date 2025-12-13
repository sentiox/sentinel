include $(TOPDIR)/rules.mk

PKG_NAME:=sentinel
PKG_VERSION:=$(if $(sentinel_VERSION),$(sentinel_VERSION),0.$(shell date +%d%m%Y))
PKG_RELEASE:=1

PKG_LICENSE:=GPL-2.0-or-later
PKG_MAINTAINER:=sentiox <sentinel@sentiox>

include $(INCLUDE_DIR)/package.mk

define Package/sentinel
	SECTION:=net
	CATEGORY:=Network
	TITLE:=Domain routing app
	DEPENDS:=+sing-box +curl +jq
	PKGARCH:=all
endef

define Package/sentinel/description
	Domain routing app
endef

define Build/Configure
endef

define Build/Compile
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
