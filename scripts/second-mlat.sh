#!/bin/bash
SERVICE="/lib/systemd/system/adsb-one-mlat2.service"

if [[ -z ${1} ]]; then
    echo --------------
    echo ERROR: requires a parameter
    exit 1
fi

cat >"$SERVICE" <<"EOF"
[Unit]
Description=adsb-one-mlat2
Wants=network.target
After=network.target

[Service]
User=adsb-one
EnvironmentFile=/etc/default/adsb-one
ExecStart=/usr/local/share/adsb-one/venv/bin/mlat-client \
    --input-type $INPUT_TYPE --no-udp \
    --input-connect $INPUT \
    --server feed.adsb.one:SERVERPORT \
    --user $USER \
    --lat $LATITUDE \
    --lon $LONGITUDE \
    --alt $ALTITUDE \
    $UUID_FILE \
    $PRIVACY \
    $RESULTS
Type=simple
Restart=always
RestartSec=30
StartLimitInterval=1
StartLimitBurst=100
SyslogIdentifier=adsb-one-mlat2
Nice=-1

[Install]
WantedBy=default.target
EOF

if [[ -f /boot/adsb-config.txt ]]; then
    sed -i -e 's#EnvironmentFile.*#EnvironmentFile=/boot/adsb-one-env\nEnvironmentFile=/boot/adsb-config.txt#' "$SERVICE"
fi

sed -i -e "s/SERVERPORT/${1}/" "$SERVICE"
if [[ -n ${2} ]]; then
    sed -i -e "s/\$RESULTS/${2}/" "$SERVICE"
fi

systemctl enable adsb-one-mlat2
systemctl restart adsb-one-mlat2