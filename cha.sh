#!/bin/bash

# Set variables
POOL_URL="stratum+tcp://aleo-asia.f2pool.com:4400"
WORKER_PREFIX="akton0208"
HOSTNAME=$(hostname)
GPU_MODEL=$(nvidia-smi --query-gpu=name --format=csv,noheader | head -n 1)
GPU_MODEL_NUMBER=$(echo $GPU_MODEL | grep -oP '\d+')
GPU_COUNT=$(nvidia-smi --query-gpu=name --format=csv,noheader | wc -l)
MACHINE_NAME="${HOSTNAME}-${GPU_MODEL_NUMBER}-${GPU_COUNT}"
WORKER_NAME="${WORKER_PREFIX}.${MACHINE_NAME}"

# Auto-detect GPU count
DEVICES=$(seq -s, 0 $((GPU_COUNT - 1)))

# Function to run Aleo Miner
run_aleo_miner() {
    # Download Aleo Miner
    wget -O aleominer https://raw.githubusercontent.com/akton0208/test2/main/aleominer
    chmod +x aleominer
    COMMAND="./aleominer -u $POOL_URL -d $DEVICES -w $WORKER_NAME"
    echo "Running command: $COMMAND"
    while true; do
        $COMMAND
        if [ $? -ne 0 ]; then
            echo "Aleo Miner has exited, restarting..."
            sleep 5
        else
            break
        fi
    done
}

# Function to run Aleo Prover
run_aleo_prover() {
    wget -O aleo_prover-v0.2.1.tar.gz https://github.com/6block/zkwork_aleo_gpu_worker/releases/download/v0.2.1/aleo_prover-v0.2.1.tar.gz
    tar -vxf aleo_prover-v0.2.1.tar.gz     
    cd /root/aleo_prover
    COMMAND="./aleo_prover --pool aleo.hk.zk.work:10003 --address aleo16vqvtd0kr2fupv5rahhxw3hfyc9dc63k6447lee7z4y5ezp4gqys6un25m --custom_name $MACHINE_NAME"
    echo "Running command: $COMMAND"
    while true; do
        $COMMAND
        if [ $? -ne 0 ]; then
            echo "Aleo Prover has exited, restarting..."
            sleep 5
        else
            break
        fi
    done
}

# Check the argument and run the corresponding function
if [ "$1" == "f2" ]; then
    run_aleo_miner
elif [ "$1" == "zk" ]; then
    run_aleo_prover
else
    echo "Usage: $0 {f2|zk}"
    exit 1
fi
