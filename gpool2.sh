#!/bin/bash

# Default wallet address
default_wallet_address="37BgmeJABVhQe9xzuG7UdD6Dy2QF7UAj2Yv7pY37yqwX"

# Check if a wallet address is provided, otherwise use the default address
wallet_address=${1:-$default_wallet_address}

git clone https://github.com/gpool-cloud/gpool-cli.git

chmod +x gpool-cli/gpool

# Function to check PCIe lanes
check_pcie_lanes() {
    gpu_id=$(lspci | grep -i nvidia | head -n 1 | awk '{print $1}')
    pcie_info=$(sudo lspci -vv -s $gpu_id | grep -i 'LnkSta:')

    echo "PCIe Info: $pcie_info"  # 輸出 PCIe 信息

    if echo $pcie_info | grep -q 'Width x8\|Width x16'; then
        return 0  # x8 or x16
    else
        return 1  # other
    fi
}

# Function to run the commands
run_command() {
    check_pcie_lanes
    if [ $? -eq 0 ]; then
        COMMAND="./gpool-cli/gpool --pubkey $wallet_address"
    else
        COMMAND="./gpool-cli/gpool --pubkey $wallet_address --no-pcie"
    fi

    $COMMAND
    return $?
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
