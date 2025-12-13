include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-sentinel

PKG_VERSION := $(if $(PKG_VERSION),$(PKG_VERSION),dev_$(shell date +%d%m%Y))

PKG_RELEASE:=1

LUCI_TITLE:=LuCI sentinel app
LUCI_DEPENDS:=+luci-base +sentinel
LUCI_PKGARCH:=all
LUCI_LANG.ru:=Русский (Russian)
LUCI_LANG.en:=English

PKG_LICENSE:=GPL-2.0-or-later
PKG_MAINTAINER:=ITDog <sentinel@sentiox>

LUCI_LANGUAGES:=en ru

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature