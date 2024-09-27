#!/bin/bash

# Download and extract the miner
wget -O oula-pool-prover https://github.com/oula-network/aleo/releases/download/v1.12/oula-pool-prover
chmod +x oula-pool-prover

# Check if the address parameter is provided, set default if not
address=${1:-akcha}

# Get GPU model and count
gpu_info=$(nvidia-smi --query-gpu=name --format=csv,noheader)
gpu_count=$(echo "$gpu_info" | wc -l)
gpu_model=$(echo "$gpu_info" | head -n 1 | grep -oP '\d{4}')  # Extract the numeric part of the model

# Get the machine name
hostname=$(hostname)

# Format as "countXmodel_hostname"
gpu_summary="${gpu_count}X${gpu_model}_${hostname}"

# Define your command
command="./oula-pool-prover --pool wss://aleo.oula.network:6666 --account $address --worker-name $gpu_summary"

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

