#!/bin/bash
set -e

[[ $EUID -ne 0 ]] && { echo "run as root."; exit 1; }

cat > /etc/rtunnel.conf <<'EOF'
REMOTE_PORT=
LOCAL_PORT=

SSH_USER=
SSH_HOST=
SSH_PORT=
SSH_KEY=/root/.ssh/tunnel_id_rsa
EOF

cat > /etc/systemd/system/rtunnel.service <<'EOF'
[Unit]
Description=SSH Reverse Tunnel
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
EnvironmentFile=/etc/rtunnel.conf
ExecStart=/usr/bin/ssh -N \
    -R ${REMOTE_PORT}:localhost:${LOCAL_PORT} \
    ${SSH_USER}@${SSH_HOST} \
    -p ${SSH_PORT} \
    -i ${SSH_KEY} \
    -o "ServerAliveInterval=30" \
    -o "ServerAliveCountMax=3" \
    -o "ExitOnForwardFailure=yes" \
    -o "StrictHostKeyChecking=accept-new"
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload

echo "done."
echo "  1. edit /etc/rtunnel.conf"
echo "  2. systemctl enable --now rtunnel"