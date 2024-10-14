#!/bin/bash

# Default wallet address
default_wallet_address="37BgmeJABVhQe9xzuG7UdD6Dy2QF7UAj2Yv7pY37yqwX"

# Check if a wallet address is provided, otherwise use the default address
wallet_address=${1:-$default_wallet_address}

apt-get update
apt-get install -y screen

wget -O gpool https://github.com/gpool-cloud/gpool-cli/raw/refs/heads/main/gpool

chmod +x gpool

# Build the final commands
COMMAND1="./gpool --pubkey $wallet_address"
COMMAND2="./gpool --pubkey $wallet_address --no-pcie"

# Function to run the commands inside screen and redirect output to ore.log
run_command() {
    screen -dmS gpu bash -c "$COMMAND2 2>&1 | tee -a ore.log"
}

# Run the command
run_command

# Restart every 15 minutes with time display and check if screen session exists
while true; do
    for ((i=15; i>0; i--)); do
        echo "Restarting in $i minutes"
        sleep 60  # Sleep for 1 minute
        
        # Check if the screen session is still running
        if ! screen -list | grep -q "gpu"; then
            echo "Screen session 'gpu' not found. Restarting..."
            run_command
        else
            echo "Screen session 'gpu' is running."
        fi
    done
    
    pkill -f gpool-cli
    run_command
done
