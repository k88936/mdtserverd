#!/bin/bash

# === Configuration ===
# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BOOT_SCRIPT="$SCRIPT_DIR/boot.sh"
# 设置服务文件路径
SERVICE_FILE="/etc/systemd/system/mindustry.service"


echo "Installing Mindustry server..."

# 写入服务单元文件内容
cat <<EOF > $SERVICE_FILE
[Unit]
Description=Mindustry game server
After=network.target

[Service]
ExecStart=/usr/bin/screen -D -m -S mindustry -p 0 -c /etc/screenrc $BOOT_SCRIPT
ExecStop=/usr/bin/screen -S mindustry -X quit
Restart=on-failure
WorkingDirectory=$SCRIPT_DIR
# TTYPath=$TTY_PATH
User=root
# StandardInput=tty
# StandardOutput=tty
Restart=on-failure
RestartSec=5s
TimeoutSec=300

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd
sudo systemctl daemon-reload

# Enable and start service
sudo systemctl enable mindustry
sudo systemctl start mindustry

echo "✅ Installation complete!"

