# Mindustry Game Server - systemd Configuration

[中文文档 / Chinese Documentation](README.zh.md)

This repository contains systemd service configuration files for running a Mindustry game server as a Linux system service.

## Overview

The Mindustry server is configured to run as a systemd service with the following features:
- Automatic startup on system boot
- Automatic restart on failure
- Running in a screen session for interactive access
- Configurable server parameters

## Files

- `boot.sh` - Server startup script with Java parameters
- `install.sh` - Installation script to set up the systemd service
- `uninstall.sh` - Uninstallation script to remove the service
- `README.md` - This documentation

## Prerequisites

Before installing, ensure you have:

1. **Java Runtime Environment (JRE)** - Required to run the Mindustry server
   ```bash
   sudo apt update
   sudo apt install openjdk-17-jre
   ```

2. **Screen utility** - Used for session management
   ```bash
   sudo apt install screen
   ```

3. **Mindustry server JAR file** - [Download](https://github.com/Anuken/Mindustry/releases) and place `server.jar` in this directory
   ```bash
   # Download the latest server from GitHub releases
   wget https://github.com/Anuken/Mindustry/releases/download/v146/server-release.jar
   mv server-release.jar server.jar
   ```

    **notice that In this project the executable jar is renamed as server.jar**
## Installation

1. **Clone or download** this repository to your server
2. **Make scripts executable**:
   ```bash
   chmod +x boot.sh install.sh uninstall.sh
   ```
3. **Place the Mindustry server JAR** file (`server.jar`) in the same directory
4. **Run the installation script**:
   ```bash
   sudo ./install.sh
   ```

The installation script will:
- Create a systemd service file at `/etc/systemd/system/mindustry.service`
- Reload systemd daemon
- Enable the service for automatic startup
- Start the Mindustry server

## Server Configuration

The server is configured with the following parameters in `boot.sh`:

- `--autoUpdate=true` - Automatically update the server
- `--autoPause=true` - Pause server when no players are connected
- `--autosave=true` - Enable automatic saving
- `--autosaveAmount=64` - Number of autosave files to keep
- `--autosaveSpacing=1024` - Time between autosaves (in game ticks)

You can modify these parameters by editing the `boot.sh` file and restarting the service.

## Service Management

### Start the service
```bash
sudo systemctl start mindustry
```

### Stop the service
```bash
sudo systemctl stop mindustry
```

### Restart the service
```bash
sudo systemctl restart mindustry
```

### Check service status
```bash
sudo systemctl status mindustry
```

### View service logs
```bash
sudo journalctl -u mindustry -f
```

### Enable/Disable automatic startup
```bash
# Enable (default after installation)
sudo systemctl enable mindustry

# Disable
sudo systemctl disable mindustry
```

## Interactive Server Access

The server runs in a screen session named `mindustry`. You can attach to it for interactive administration:

```bash
# Attach to the server console
sudo screen -r mindustry

# Detach from the session (Ctrl+A, then D)
# Do NOT use Ctrl+C as this will terminate the server
```

### Common Server Commands

see [official wiki](https://mindustrygame.github.io/wiki/servers/)

## Uninstallation

To remove the Mindustry server service:

```bash
sudo ./uninstall.sh
```

This will:
- Stop the running service
- Disable the service from automatic startup
- Remove the systemd service file
- Reload systemd daemon

## Troubleshooting

### Service won't start
1. Check if Java is installed: `java -version`
2. Verify `server.jar` exists in the script directory
3. Check service logs: `sudo journalctl -u mindustry -n 50`
4. Ensure scripts are executable: `ls -la *.sh`

### Can't connect to server
1. Check if the service is running: `sudo systemctl status mindustry`
2. Verify network connectivity and firewall settings
3. Default Mindustry port is 6567 (*UDP* and TCP)

### Server crashes frequently
1. Check available system memory
2. Review server logs for error messages
3. Consider adjusting Java memory parameters in `boot.sh`:
   ```bash
   exec java -Xmx2G -jar server.jar host \
   ```

## Network Configuration

Mindustry server uses port **6567** by default. Ensure this port is:
- Open in your firewall
- Forwarded in your router (if hosting from behind NAT)

### UFW Firewall Example
```bash
sudo ufw allow 6567
```

### Firewall-cmd Example (CentOS/RHEL/Fedora)
```bash
sudo firewall-cmd --permanent --add-port=6567/tcp
sudo firewall-cmd --permanent --add-port=6567/udp
sudo firewall-cmd --reload
```

## File Locations

- Service file: `/etc/systemd/system/mindustry.service`
- Server files: Current directory where scripts are located
- Game data: `~/.local/share/Mindustry/` (server saves, maps, etc.)

## Support

For Mindustry-specific issues, refer to:
- [Official Mindustry GitHub](https://github.com/Anuken/Mindustry)
- [Mindustry Wiki](https://mindustrygame.github.io/wiki/)
- [Community Discord](https://discord.gg/mindustry)

For systemd service issues, check the system logs and ensure all prerequisites are met.
