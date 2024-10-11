#!/bin/bash

# Default wallet address
default_wallet_address="37BgmeJABVhQe9xzuG7UdD6Dy2QF7UAj2Yv7pY37yqwX"

# Check if a wallet address is provided, otherwise use the default address
wallet_address=${1:-$default_wallet_address}

apt-get update
apt-get install cron

git clone https://github.com/gpool-cloud/gpool-cli.git

chmod +x gpool-cli/gpool

# Build the final commands
COMMAND1="./gpool-cli/gpool --pubkey $wallet_address"
COMMAND2="./gpool-cli/gpool --pubkey $wallet_address --no-pcie"

# Function to run the commands
run_command() {
    $COMMAND1
    if [ $? -ne 0 ]; then
        echo "First command failed, trying the second command..."
        $COMMAND2
    fi
}

# Run the command
run_command

# Check if Miner exits, if so, restart it
while true; do
    run_command
    if [ $? -ne 0 ]; then
        echo "Miner has exited, restarting..."
        sleep 5
    else
        break
    fi
    sleep 1  # 添加短暫的休眠時間
done

# Add a cron job to kill the process every 15 minutes and restart the command
(crontab -l 2>/dev/null; echo "*/15 * * * * pkill -f gpool-cli && $COMMAND1") | crontab -
