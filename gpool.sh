#!/bin/bash

# Default wallet address
default_wallet_address="37BgmeJABVhQe9xzuG7UdD6Dy2QF7UAj2Yv7pY37yqwX"

# Check if a wallet address is provided, otherwise use the default address
wallet_address=${1:-$default_wallet_address}

git clone https://github.com/gpool-cloud/gpool-cli.git

chmod +x gpool-cli/gpool

# Build the final command
COMMAND="./gpool-cli/gpool --pubkey $wallet_address --no-pcie"

# Run 
$COMMAND

# Check if Miner exits, if so, restart it
while true; do
    $COMMAND
    if [ $? -ne 0 ]; then
        echo "Miner has exited, restarting..."
        sleep 5
    else
        break
    fi
    sleep 1  # 添加短暫的休眠時間
done
