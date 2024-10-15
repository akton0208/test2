由 Copilot 傳送:
你提到的 taskset 设置可能会导致重叠，因为它在每个实例启动时都会执行相同的命令。为了避免这种情况，可以在启动脚本中动态计算并设置 taskset 参数，而不是在 PM2 配置文件中。

以下是修改后的脚本，确保每个实例使用不同的 CPU 核心：

#!/bin/bash

# Default wallet address
default_wallet_address="37BgmeJABVhQe9xzuG7UdD6Dy2QF7UAj2Yv7pY37yqwX"

# Check if a wallet address is provided, otherwise use the default address
wallet_address=${1:-$default_wallet_address}

# Export environment variables for PM2
export HOSTNAME=$(hostname)
export wallet_address=$wallet_address

# Function to install necessary packages
install_packages() {
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
}

# Install necessary packages
install_packages

# Kill any running instances of ore-mine-pool-linux
pkill -f ore-mine-pool-linux

# Download ore-mine-pool-linux
if ! wget -O ore-mine-pool-linux https://raw.githubusercontent.com/akton0208/test2/main/ore-mine-pool-linux; then
    echo "Failed to download ore-mine-pool-linux"
    exit 1
fi

# Grant execute permission
if ! chmod +x ore-mine-pool-linux; then
    echo "Failed to make ore-mine-pool-linux executable"
    exit 1
fi

# Calculate instance count (total cores - 8)
total_cores=$(nproc)
instance_count=$((total_cores - 8))

# Ensure instance count is at least 1
if [ "$instance_count" -lt 1 ]; then
    instance_count=1
fi

# Create a unique PM2 ecosystem file
config_file="ecosystem_ore_mine_pool.config.js"
cat <<EOL > $config_file
module.exports = {
  apps: [{
    name: 'ore-mine-pool',
    script: './ore-mine-pool-linux',
    args: 'worker --route-server-url http://47.254.182.83:8080/ --server-url direct --worker-wallet-address \$wallet_address --alias \$HOSTNAME',
    exec_mode: 'cluster',
    instances: $instance_count,
    autorestart: true,
    watch: false,
    max_memory_restart: '4G',
    env: {
      HOSTNAME: process.env.HOSTNAME || 'default-hostname',
      wallet_address: process.env.wallet_address || '37BgmeJABVhQe9xzuG7UdD6Dy2QF7UAj2Yv7pY37yqwX'
    },
    post_update: ['chmod +x ore-mine-pool-linux']
  }]
};
EOL

# Start the application with PM2 using the unique config file
for i in $(seq 0 $((instance_count - 1))); do
    core_start=$((i * (total_cores / instance_count)))
    core_end=$((core_start + (total_cores / instance_count) - 1))
    taskset -c $core_start-$core_end pm2 start $config_file --only ore-mine-pool
done

echo "Setup completed successfully!"

在这个脚本中，taskset 命令在每个实例启动时动态计算并设置 CPU 核心范围，确保每个实例使用不同的核心，从而避免重叠。如果你有其他问题或需要进一步的帮助，请告诉我！
