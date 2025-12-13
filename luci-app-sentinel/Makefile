include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-sentinel
PKG_RELEASE:=1

LUCI_TITLE:=LuCI support for Sentinel
LUCI_DEPENDS:=+luci-base +sentinel
LUCI_PKGARCH:=all

include $(TOPDIR)/feeds/luci/luci.mk

define Package/luci-app-sentinel/install
	$(INSTALL_DIR) $(1)/usr/share/luci/menu.d
	$(INSTALL_DATA) ./root/usr/share/luci/menu.d/sentinel.json \
		$(1)/usr/share/luci/menu.d/

	$(INSTALL_DIR) $(1)/www/luci-static/resources/view/sentinel
	$(CP) ./htdocs/luci-static/resources/view/sentinel/* \
		$(1)/www/luci-static/resources/view/sentinel/
endef

$(eval $(call BuildPackage,luci-app-sentinel))
