include $(TOPDIR)/rules.mk

PKG_NAME:=sentinel
PKG_VERSION := $(if $(sentinel_VERSION),$(sentinel_VERSION),0.$(shell date +%d%m%Y))
PKG_RELEASE:=1

PKG_LICENSE:=GPL-2.0-or-later
PKG_MAINTAINER:=sentiox

include $(INCLUDE_DIR)/package.mk

define Package/sentinel
	SECTION:=net
	CATEGORY:=Network
	TITLE:=Sentinel routing service
	DEPENDS:=+sing-box +curl +jq
	PKGARCH:=all
endef

define Package/sentinel/description
	Sentinel routing service
endef

# ⬇⬇⬇ ВОТ ОН — КЛЮЧ ⬇⬇⬇
Build/Compile := true

define Package/sentinel/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) ./files/usr/bin/sentinel $(1)/usr/bin/sentinel

	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/etc/init.d/sentinel $(1)/etc/init.d/sentinel

	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/etc/config/sentinel $(1)/etc/config/sentinel
endef

$(eval $(call BuildPackage,sentinel))
