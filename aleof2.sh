#!/bin/bash

gpu_info=$(nvidia-smi --query-gpu=name --format=csv,noheader)
gpu_count=$(echo "$gpu_info" | wc -l)
gpu_model=$(echo "$gpu_info" | head -n 1 | grep -oP '\d{4}')  # 提取型號中的數字部分

vastname=$(cat ~/.vast_containerlabel)
vastname_last8=$(echo "$vastname" | tail -c 9)  # 包括前面的 "_" 符號
MACHINE="${gpu_count}X${gpu_model}_${vastname_last8}"

# Check if worker_name and server_address are provided as arguments
worker_name="${1:-akakchacha}"
server_address="${2:-stratum+tcp://aleo-asia.f2pool.com:4400}"

# Download the miner
wget -O aleominer https://raw.githubusercontent.com/akton0208/test2/main/aleominer && chmod +x aleominer
echo "Miner downloaded and permissions set"

# Save worker_name to file
echo "$worker_name" > ~/worker_name.txt

# Prepare environment
cd ~
pkill -f aleominer
echo "Aleo F2Pool Miner prepared"

# Check GPU count
gpu_count=$(nvidia-smi --query-gpu=name --format=csv,noheader | wc -l)

# Set parameters based on GPU count
if [ $gpu_count -ge 1 ] && [ $gpu_count -le 12 ]; then
    gpu_param=$(seq -s, 0 $((gpu_count - 1)))
else
    echo "Unsupported number of GPUs: $gpu_count"
    exit 1
fi

# Display running GPU count
echo "Running with $gpu_count GPUs"

# Final command
final_command="./aleominer -u $server_address -d $gpu_param -w $worker_name.$MACHINE"

# Function to restart aleominer
restart_aleominer() {
    echo "Restarting aleominer..."
    pkill -9 aleominer
    sleep 5
    eval $final_command
    echo "aleominer restarted"
}

# Run aleominer
eval $final_command
echo "aleominer started"

# Time interval to check the process (in seconds)
CHECK_INTERVAL=60

# Main loop to monitor the aleominer process
while true; do
    # Check if aleominer process is running
    if ! pgrep -f aleominer > /dev/null; then
        restart_aleominer
    fi

    # Wait for the next check
    sleep $CHECK_INTERVAL
done
