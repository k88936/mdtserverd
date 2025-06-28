# Mindustry 游戏服务器 - systemd 配置

本仓库包含用于将 Mindustry 游戏服务器作为 Linux 系统服务运行的 systemd 服务配置文件。

## 概述

Mindustry 服务器配置为 systemd 服务，具有以下特性：
- 系统启动时自动启动
- 失败时自动重启
- 在 screen 会话中运行以便交互式访问
- 可配置的服务器参数

## 文件

- `boot.sh` - 带有 Java 参数的服务器启动脚本
- `install.sh` - 设置 systemd 服务的安装脚本
- `uninstall.sh` - 移除服务的卸载脚本
- `README.md` - 英文文档
- `README.zh.md` - 中文文档

## 先决条件

安装前，请确保您具备：

1. **Java 运行时环境 (JRE)** - 运行 Mindustry 服务器所需
   ```bash
   sudo apt update
   sudo apt install openjdk-17-jre
   ```

2. **Screen 工具** - 用于会话管理
   ```bash
   sudo apt install screen
   ```

3. **Mindustry 服务器 JAR 文件** - [下载](https://github.com/Anuken/Mindustry/releases) 并将 `server.jar` 放置在此目录中
   ```bash
   # 从 GitHub 发布页面下载最新服务器
   wget https://github.com/Anuken/Mindustry/releases/download/v146/server-release.jar
   mv server-release.jar server.jar
   ```

    **注意：在此项目中，可执行 jar 文件被重命名为 server.jar**

## 安装

1. **克隆或下载** 此仓库到您的服务器
2. **使脚本可执行**：
   ```bash
   chmod +x boot.sh install.sh uninstall.sh
   ```
3. **放置 Mindustry 服务器 JAR** 文件 (`server.jar`) 到同一目录
4. **运行安装脚本**：
   ```bash
   sudo ./install.sh
   ```

安装脚本将：
- 在 `/etc/systemd/system/mindustry.service` 创建 systemd 服务文件
- 重新加载 systemd 守护进程
- 启用服务以便自动启动
- 启动 Mindustry 服务器

## 服务器配置

服务器在 `boot.sh` 中配置了以下参数：

- `--autoUpdate=true` - 自动更新服务器
- `--autoPause=true` - 无玩家连接时暂停服务器
- `--autosave=true` - 启用自动保存
- `--autosaveAmount=64` - 保留的自动保存文件数量
- `--autosaveSpacing=1024` - 自动保存间隔时间（游戏刻）

您可以通过编辑 `boot.sh` 文件并重启服务来修改这些参数。

## 服务管理

### 启动服务
```bash
sudo systemctl start mindustry
```

### 停止服务
```bash
sudo systemctl stop mindustry
```

### 重启服务
```bash
sudo systemctl restart mindustry
```

### 检查服务状态
```bash
sudo systemctl status mindustry
```

### 查看服务日志
```bash
sudo journalctl -u mindustry -f
```

### 启用/禁用自动启动
```bash
# 启用（安装后默认）
sudo systemctl enable mindustry

# 禁用
sudo systemctl disable mindustry
```

## 交互式服务器访问

服务器在名为 `mindustry` 的 screen 会话中运行。您可以连接到它进行交互式管理：

```bash
# 连接到服务器控制台
sudo screen -r mindustry

# 从会话中分离（Ctrl+A，然后按 D）
# 请勿使用 Ctrl+C，这会终止服务器
```

### 常用服务器命令

参见 [官方wiki](https://mindustrygame.github.io/wiki/servers/)

## 卸载

要移除 Mindustry 服务器服务：

```bash
sudo ./uninstall.sh
```

这将：
- 停止运行中的服务
- 禁用服务的自动启动
- 移除 systemd 服务文件
- 重新加载 systemd 守护进程

## 故障排除

### 服务无法启动
1. 检查 Java 是否已安装：`java -version`
2. 验证 `server.jar` 存在于脚本目录中
3. 检查服务日志：`sudo journalctl -u mindustry -n 50`
4. 确保脚本可执行：`ls -la *.sh`

### 无法连接到服务器
1. 检查服务是否正在运行：`sudo systemctl status mindustry`
2. 验证网络连接和防火墙设置
3. Mindustry 默认端口是 6567（*UDP* 和 TCP）

### 服务器频繁崩溃
1. 检查可用系统内存
2. 查看服务器日志中的错误消息
3. 考虑调整 `boot.sh` 中的 Java 内存参数：
   ```bash
   exec java -Xmx2G -jar server.jar host \
   ```

## 网络配置

Mindustry 服务器默认使用端口 **6567**。确保此端口：
- 在防火墙中开放
- 在路由器中转发（如果在 NAT 后面托管）

### UFW 防火墙示例
```bash
sudo ufw allow 6567
```

### Firewall-cmd 示例 (CentOS/RHEL/Fedora)
```bash
sudo firewall-cmd --permanent --add-port=6567/tcp
sudo firewall-cmd --permanent --add-port=6567/udp
sudo firewall-cmd --reload
```

## 文件位置

- 服务文件：`/etc/systemd/system/mindustry.service`
- 服务器文件：脚本所在的当前目录
- 游戏数据：`~/.local/share/Mindustry/`（服务器存档、地图等）

## 支持

对于 Mindustry 特定问题，请参考：
- [Mindustry 官方 GitHub](https://github.com/Anuken/Mindustry)
- [Mindustry Wiki](https://mindustrygame.github.io/wiki/)
- [社区 Discord](https://discord.gg/mindustry)

对于 systemd 服务问题，请检查系统日志并确保满足所有先决条件。
