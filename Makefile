# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2022-2023 ImmortalWrt.org
#

include $(TOPDIR)/rules.mk

LUCI_TITLE:=The modern ImmortalWrt proxy platform for ARM64/AMD64 (sing-box 1.14)
LUCI_PKGARCH:=all

# `cron` is a real dependency, not a convenience: runtime/service.sh writes two
# entries into /etc/crontabs/root and calls `/etc/init.d/cron restart`
# (hp_sync_resource_cron, hp_sync_autoupdate_cron, hp_clear_autoupdate_cron),
# and the resource-list refresh and the subscription update only ever run from
# those entries.  Without the package the writes still succeed - a crontab file
# is just a file - so the router looks fine while neither the China lists nor
# the subscriptions are ever refreshed again, and the only trace is a Warning
# in the log from the failed `cron restart`.  Most images ship it, which is
# exactly why the omission went unnoticed.
LUCI_DEPENDS:= \
	+sing-box \
	+firewall4 \
	+kmod-nft-tproxy \
    +ip-full \
    +kmod-tun \
	+uclient-fetch \
	+cron \
	+ucode-mod-digest

PKG_NAME:=luci-app-homeproxy
PKG_VERSION:=28.10.1.14
PKG_RELEASE:=45

LUCI_BASENAME:=homeproxy

define Package/luci-app-homeproxy/conffiles
/etc/config/homeproxy
/etc/homeproxy/resources/china_ip4.txt
/etc/homeproxy/resources/china_ip6.txt
/etc/homeproxy/resources/china_list.txt
/etc/homeproxy/resources/gfw_list.txt
/etc/homeproxy/resources/china_ip4.ver
/etc/homeproxy/resources/china_ip6.ver
/etc/homeproxy/resources/china_list.ver
/etc/homeproxy/resources/gfw_list.ver
endef

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
