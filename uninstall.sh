#!/bin/bash
set -x

IPATH=/usr/local/share/adsb-one

systemctl disable --now adsb-one-mlat
systemctl disable --now adsb-one-mlat2 &>/dev/null
systemctl disable --now adsb-one-feed

if [[ -d /usr/local/share/tar1090/html-adsb-one ]]; then
    bash /usr/local/share/tar1090/uninstall.sh adsb-one
fi

rm -f /lib/systemd/system/adsb-one-mlat.service
rm -f /lib/systemd/system/adsb-one-mlat2.service
rm -f /lib/systemd/system/adsb-one-feed.service

cp -f "$IPATH/adsb-one-uuid" /tmp/adsb-one-uuid
rm -rf "$IPATH"
mkdir -p "$IPATH"
mv -f /tmp/adsb-one-uuid "$IPATH/adsb-one-uuid"

set +x

echo -----
echo "adsb.one feed scripts have been uninstalled!"