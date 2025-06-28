#!/bin/bash

# === Configuration ===
# 设置服务文件路径
SERVICE_FILE="/etc/systemd/system/mindustry.service"

echo "Uninstalling Minudstry server"

# Stop and disable service
if systemctl is-active --quiet mindustry; then
    sudo systemctl stop mindustry
fi
sudo systemctl disable mindustry

# Remove service file
if [ -f "$SERVICE_DST" ]; then
    sudo rm "$SERVICE_DST"
    echo "Removed systemd service."
else
    echo "Service not found, skipping removal."
fi

# Reload systemd
sudo systemctl daemon-reload

echo "✅ Uninstallation complete!"

