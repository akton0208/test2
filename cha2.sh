#!/bin/bash

# Set variables
POOL_URL="stratum+tcp://172.81.133.6:4400"
WORKER_PREFIX="akakchacha"
HOSTNAME=$(hostname)
GPU_MODEL=$(nvidia-smi --query-gpu=name --format=csv,noheader | head -n 1)
GPU_MODEL_NUMBER=$(echo $GPU_MODEL | grep -oP '\d+')
GPU_COUNT=$(nvidia-smi --query-gpu=name --format=csv,noheader | wc -l)
MACHINE_NAME="${HOSTNAME}-${GPU_MODEL_NUMBER}-${GPU_COUNT}"
WORKER_NAME="${WORKER_PREFIX}.${MACHINE_NAME}"

# Auto-detect GPU count
DEVICES=$(seq -s, 0 $((GPU_COUNT - 1)))

# Build the final command
COMMAND="./aleominer -u $POOL_URL -d $DEVICES -w $WORKER_NAME"

# Output the final command
echo "Running command: $COMMAND"

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

