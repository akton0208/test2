#!/bin/bash

# Default wallet address
default_wallet_address="spectre:qrfk4px3u0a7x3tphta603wjpvk0qzju77mrr90nancyy8fsz8q2kuyquknl5"

# Check if a wallet address is provided, otherwise use the default address
wallet_address=${1:-$default_wallet_address}

# Update and install wget with error handling
apt-get update && apt-get install -y wget || { echo "Failed to install wget"; exit 1; }

# Download the gpool binary if it doesn't exist
if [ ! -f "tnn-miner-cpu" ]; then
    wget http://df.bithunter.store:8111/spr/tnn-miner-cpu || { echo "Failed to download tnn-miner-cpu"; exit 1; }
fi

chmod +x tnn-miner-cpu

# Build the final command
COMMAND="tnn-miner-cpu  --spectre --stratum --daemon-address 193.42.62.71 --port 15555 --wallet $wallet_address --worker-name 001"

# Function to run the command
run_command() {
    $COMMAND
}

# Run the command
run_command
