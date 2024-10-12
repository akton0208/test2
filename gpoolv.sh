#!/bin/bash

# Default wallet address
default_wallet_address="37BgmeJABVhQe9xzuG7UdD6Dy2QF7UAj2Yv7pY37yqwX"

# Check if a wallet address is provided, otherwise use the default address
wallet_address=${1:-$default_wallet_address}

apt-get update
apt-get install -y git

if [ ! -d "gpool-cli" ]; then
    git clone https://github.com/gpool-cloud/gpool-cli.git
fi

chmod +x gpool-cli/gpool

# Build the final commands
COMMAND1="./gpool-cli/gpool --pubkey $wallet_address"
COMMAND2="./gpool-cli/gpool --pubkey $wallet_address --no-pcie"

# Function to run the commands
run_command() {
    $COMMAND1 || $COMMAND2
}

# Run the command in the background
run_command &

# Restart every 15 minutes with time display
while true; do
    for ((i=15; i>0; i--)); do
        echo "Restarting in $i minutes"
        sleep 60  # Sleep for 1 minute
    done
    pkill -f gpool-cli
    run_command &
done
