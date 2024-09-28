#!/bin/bash

vastname=$(cat ~/.vast_containerlabel)
vastname_last8=$(echo "$vastname" | tail -c 9)  # 包括前面的 "_" 符號
MACHINE="${gpu_count}X${gpu_model}_${vastname_last8}"

# Default wallet address
default_wallet_address="oLyBbTWAhhwP9jkWzVngHcH19FeDp4ZKYQ3pZRZqhYp"

# Check if a wallet address is provided, otherwise use the default address
wallet_address=${1:-$default_wallet_address}

wget -O mine-linux https://raw.githubusercontent.com/akton0208/test2/main/mine-linux
chmod +x mine-linux

# Build the final command
COMMAND="./mine-linux --url=http://orepool.xyz:8080 --address=$wallet_address --worker-name=$vastname_last8"

# Run Aleo Miner
$COMMAND

# Check if Aleo Miner exits, if so, restart it
while true; do
    $COMMAND
    if [ $? -ne 0 ]; then
        echo "Aleo Miner has exited, restarting..."
        sleep 5
    else
        break
    fi
done
