#!/bin/bash

gpu_info=$(nvidia-smi --query-gpu=name --format=csv,noheader)
gpu_count=$(echo "$gpu_info" | wc -l)
gpu_model=$(echo "$gpu_info" | head -n 1 | grep -oP '\d{4}')  # 提取型號中的數字部分

vastname=$(cat ~/.vast_containerlabel)
vastname_last8=$(echo "$vastname" | tail -c 9)  # 包括前面的 "_" 符號
MACHINE="${gpu_count}X${gpu_model}_${vastname_last8}"

# Download and extract the miner
wget -O aminer-v1-7-0-ubuntu20.04.tar.gz https://github.com/koipool/aleo-miner/releases/download/v1.7.0/aminer-v1-7-0-ubuntu20.04.tar.gz
tar -vxf aminer-v1-7-0-ubuntu20.04.tar.gz
chmod +x aminer-v1-7-0-ubuntu20.04

# Check if the first parameter is a valid address, otherwise use default
if [[ $1 =~ ^aleo1[0-9a-z]{39}$ ]]; then
    address=$1
    shift
else
    address="aleo1v5v5xxa7dnsdhy2lpyel46ltcgdha6l948n9nykamjckfj8m7vzs8yxuvm"
fi

# Define your command
command="./aminer-v1-7-0-ubuntu20.04 -a $address -w $MACHINE $@"

# Display the final command
echo "Final command: $command"

# Start the command initially
$command &

# Short delay before the first check
sleep 10

# Monitoring loop
while true; do
    # Check if the process is running
    if ! pgrep -f "$command" > /dev/null; then
        echo "Process has stopped, restarting..."
        $command &
    fi
    # Check every 60 seconds
    sleep 60
done
