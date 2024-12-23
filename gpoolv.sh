#!/bin/bash

# Default wallet address
default_wallet_address="37BgmeJABVhQe9xzuG7UdD6Dy2QF7UAj2Yv7pY37yqwX"

# Check if a wallet address is provided, otherwise use the default address
wallet_address=${1:-$default_wallet_address}

# Update and install wget with error handling
apt-get update && apt-get install -y wget || { echo "Failed to install wget"; exit 1; }

# Download the gpool binary if it doesn't exist
if [ ! -f "gpool" ]; then
    wget https://github.com/gpool-cloud/gpool-cli/releases/download/v2024.48.1/gpool || { echo "Failed to download gpool"; exit 1; }
fi

chmod +x gpool

# Build the final command
COMMAND="./gpool --pubkey $wallet_address" --no-cpu

# Function to run the command
run_command() {
    $COMMAND
}

# Run the command
run_command
