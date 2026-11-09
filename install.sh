#!/bin/sh
echo "========================================="
echo "  DANG CAI DAT KHANH ROUTER OS v8.0"
echo "========================================="

echo "1. Dang xoa giao dien OpenWrt mac dinh (LuCI) va giai phong port 80..."
/etc/init.d/uhttpd stop
/etc/init.d/uhttpd disable
opkg update
opkg remove luci* uhttpd* --force-depends

echo "2. Dang cai dat cac goi phu thuoc (Python)..."
opkg install python3 python3-flask curl

echo "3. Dang tai va giai nen ma nguon..."
mkdir -p /root/router_ui
wget -qO /tmp/krouter.tar.gz "blob:https://github.com/112117ad-aa00-4020-b8a0-67e6e799459f"
tar -xzvf /tmp/krouter.tar.gz -C /root/router_ui/
rm /tmp/krouter.tar.gz

echo "4. Thiet lap dich vu khoi dong cung router..."
cat << 'EOF' > /etc/init.d/khanh-router
#!/bin/sh /etc/rc.common
START=99
USE_PROCD=1
start_service() {
    procd_open_instance
    procd_set_param command /usr/bin/python3 /root/router_ui/app.pyc
    procd_set_param respawn
    procd_close_instance
}
EOF
chmod +x /etc/init.d/khanh-router
/etc/init.d/khanh-router enable
/etc/init.d/khanh-router start

echo "========================================="
echo "  CAI DAT THANH CONG!"
echo "  Vui long truy cap vao IP cua Router."
echo "========================================="