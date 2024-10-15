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

# Create a unique PM2 ecosystem file
config_file="ecosystem_ore_mine_pool.config.js"
cat <<EOL > $config_file
module.exports = {
  apps: [{
    name: 'ore-mine-pool',
    script: './ore-mine-pool-linux',
    args: 'worker --route-server-url http://47.254.182.83:8080/ --server-url direct --worker-wallet-address \$wallet_address --alias \$HOSTNAME',
    exec_mode: 'fork',
    instances: 1,
    autorestart: true,
    watch: false,
    max_memory_restart: '1G',
    env: {
      HOSTNAME: process.env.HOSTNAME || 'default-hostname',
      wallet_address: process.env.wallet_address || '37BgmeJABVhQe9xzuG7UdD6Dy2QF7UAj2Yv7pY37yqwX'
    },
    post_update: ['chmod +x ore-mine-pool-linux'],
    pre_start: 'taskset -c 0-$(($(nproc) - 8))'
  }]
};
EOL

# Start the application with PM2 using the unique config file
if ! pm2 start $config_file; then
    echo "Failed to start the application with PM2"
    exit 1
fi

echo "Setup completed successfully!"
