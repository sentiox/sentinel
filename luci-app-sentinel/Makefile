include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-sentinel
PKG_RELEASE:=1

PKG_MAINTAINER:=Sentinel Project <support@sentinel.local>
PKG_LICENSE:=GPL-2.0-or-later

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/luci/luci.mk

LUCI_TITLE:=LuCI Sentinel
LUCI_DEPENDS:=+luci-base +sentinel
LUCI_PKGARCH:=all

define Package/luci-app-sentinel/conffiles
endef

# call BuildPackage - OpenWrt buildroot signature
