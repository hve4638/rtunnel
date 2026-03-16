# rtunnel

SSH reverse tunnel as a systemd service.

## Install

```bash
curl -sS https://raw.githubusercontent.com/hve4638/rtunnel/refs/heads/main/rtunnel.sh | sudo bash
```

## Usage

1. Edit `/etc/rtunnel.conf`

```
REMOTE_PORT=8080
LOCAL_PORT=3000

SSH_USER=sshonly
SSH_HOST=1.2.3.4
SSH_PORT=7022
SSH_KEY=/root/.ssh/tunnel_id_rsa
```

2. Start

```bash
sudo systemctl enable --now rtunnel
```

3. Check

```bash
journalctl -u rtunnel -f
```