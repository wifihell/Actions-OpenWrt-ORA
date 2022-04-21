#!/bin/bash
#============================================================
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#============================================================

# Modify default IP
#sed -i 's/192.168.1.1/192.168.1.110/g' package/base-files/files/bin/config_generate
sed -i 's/192.168.1.1/10.0.0.1/g' package/base-files/files/bin/config_generate
sed -i 's/OpenWrt/Way/g' package/base-files/files/bin/config_generate
cp -f files/banner package/base-files/files/etc/banner >/dev/null 2>&1
mkdir -p package/base-files/files/etc/profile.d/
cp -f files/30-sysinfo.sh package/base-files/files/etc/profile.d/30-sysinfo.sh >/dev/null 2>&1
sed -i '/option Interface/s/^#\?/#/'  package/network/services/dropbear/files/dropbear.config
sed -i 's/100/11/g' package/network/services/dnsmasq/files/dhcp.conf
sed -i 's/150/250/g' package/network/services/dnsmasq/files/dhcp.conf

sed -i "/uci commit/a uci commit network"  package/base-files/files/bin/config_generate
sed -i "/uci commit network/i uci set network.lan.ifname='eth0 eth1 eth2'"  package/base-files/files/bin/config_generate
sed -i "/uci commit network/i uci set network.wan.ifname='eth3'"  package/base-files/files/bin/config_generate
sed -i "/uci commit network/i uci set network.wan6.ifname='eth3'"  package/base-files/files/bin/config_generate

sed -i "/uci commit/a uci commit firewall"  package/base-files/files/bin/config_generate
sed -i "/uci commit firewall/i uci set firewall.web=rule"  package/base-files/files/bin/config_generate
sed -i "/uci commit firewall/i uci set firewall.web.target='ACCEPT'"  package/base-files/files/bin/config_generate
sed -i "/uci commit firewall/i uci set firewall.web.src='wan'"  package/base-files/files/bin/config_generate
sed -i "/uci commit firewall/i uci set firewall.web.proto='tcp'"  package/base-files/files/bin/config_generate
sed -i "/uci commit firewall/i uci set firewall.web.name='HTTP'"  package/base-files/files/bin/config_generate
sed -i "/uci commit firewall/i uci set firewall.web.dest_port='80'"  package/base-files/files/bin/config_generate
sed -i "/uci commit firewall/i uci set firewall.ssh=rule"  package/base-files/files/bin/config_generate
sed -i "/uci commit firewall/i uci set firewall.ssh.target='ACCEPT'"  package/base-files/files/bin/config_generate
sed -i "/uci commit firewall/i uci set firewall.ssh.src='wan'"  package/base-files/files/bin/config_generate
sed -i "/uci commit firewall/i uci set firewall.ssh.proto='tcp'"  package/base-files/files/bin/config_generate
sed -i "/uci commit firewall/i uci set firewall.ssh.dest_port='22'"  package/base-files/files/bin/config_generate
sed -i "/uci commit firewall/i uci set firewall.ssh.name='SSH'"  package/base-files/files/bin/config_generate

git clone https://github.com/frainzy1477/luci-app-clash.git package/luci-app-clash
#git clone https://github.com/rufengsuixing/luci-app-adguardhome.git package/luci-app-adguardhome
git clone -b master  https://github.com/vernesong/OpenClash.git package/luci-app-openclash

svn co --force https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-zerotier package/luci-app-zerotier && svn revert -R package/luci-app-zerotier
svn co --force https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-softethervpn package/luci-app-softethervpn && svn revert -R package/luci-app-softethervpn
svn co --force https://github.com/kenzok8/openwrt-packages/trunk/luci-app-adguardhome package/luci-app-adguardhome && svn revert -R package/luci-app-adguardhome
