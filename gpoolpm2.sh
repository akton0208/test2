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

if ! apt-get install -y wget curl; then
    echo "Failed to install wget and curl"
    exit 1
fi

# Install Node.js
curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
if ! apt-get install -y nodejs; then
    echo "Failed to install Node.js"
    exit 1
fi

# Install PM2
if ! npm install -g pm2; then
    echo "Failed to install PM2"
    exit 1
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
    args: '--pubkey $wallet_address --no-pcie',
    restart_delay: 900000, // 15 minutes in milliseconds
    autorestart: true,
    watch: false
  }]
};
EOL

# Start the application with PM2
pm2 start ecosystem.config.js
