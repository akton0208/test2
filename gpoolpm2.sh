#!/bin/bash

# Default wallet address
default_wallet_address="37BgmeJABVhQe9xzuG7UdD6Dy2QF7UAj2Yv7pY37yqwX"

# Check if a wallet address is provided, otherwise use the default address
wallet_address=${1:-$default_wallet_address}

# Update system and install necessary packages
if ! apt-get update; then
    echo "Failed to update package list"
    exit 1
fi

# Check if wget and curl are installed, if not, install them
if ! command -v wget &> /dev/null || ! command -v curl &> /dev/null; then
    if ! apt-get install -y wget curl; then
        echo "Failed to install wget and curl"
        exit 1
    fi
else
    echo "wget and curl are already installed"
fi

# Check if Node.js is installed, if not, install it
if ! command -v node &> /dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
    if ! apt-get install -y nodejs; then
        echo "Failed to install Node.js"
        exit 1
    fi
else
    echo "Node.js is already installed"
fi

# Check if PM2 is installed, if not, install it
if ! command -v pm2 &> /dev/null; then
    if ! npm install -g pm2; then
        echo "Failed to install PM2"
        exit 1
    fi
else
    echo "PM2 is already installed"
fi

# Download gpool
if ! wget -O gpool https://github.com/gpool-cloud/gpool-cli/raw/refs/heads/main/gpool; then
    echo "Failed to download gpool"
    exit 1
fi

# Make gpool executable
if ! chmod +x gpool; then
    echo "Failed to make gpool executable"
    exit 1
fi

# Create a PM2 ecosystem file
cat <<EOL > ecosystem.config.js
module.exports = {
  apps: [{
    name: 'gpool',
    script: './gpool',
    args: '--pubkey $wallet_address',
    restart_delay: 900000, // 15 分钟（以毫秒为单位）
    autorestart: true, // 自动重启
    watch: false, // 不监视文件变化
    min_uptime: 30000, // 最小正常运行时间（毫秒）
    exp_backoff_restart_delay: 100, // 指数退避重启延迟（毫秒）
    kill_timeout: 1600, // 杀死进程前的等待时间（毫秒）
    listen_timeout: 8000 // 等待应用程序启动的时间（毫秒）
  }]
};
EOL

# Start the application with PM2
if ! pm2 start ecosystem.config.js; then
    echo "Failed to start the application with PM2"
    exit 1
fi

echo "Setup completed successfully!"
