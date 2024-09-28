#!/bin/bash

# Set variables
HOSTNAME=$(hostname)
GPU_MODEL=$(nvidia-smi --query-gpu=name --format=csv,noheader | head -n 1)
GPU_MODEL_NUMBER=$(echo $GPU_MODEL | grep -oP '\d+')
GPU_COUNT=$(nvidia-smi --query-gpu=name --format=csv,noheader | wc -l)
MACHINE_NAME="${HOSTNAME}-${GPU_MODEL_NUMBER}-${GPU_COUNT}"

# Auto-detect GPU count
DEVICES=$(seq -s, 0 $((GPU_COUNT - 1)))

# Function to run Aleo Miner
run_aleo_miner() {
    # Download Aleo Miner
    wget -O aleominer https://raw.githubusercontent.com/akton0208/test2/main/aleominer
    if [ $? -ne 0 ]; then
        echo "Failed to download Aleo Miner"
        exit 1
    fi
    chmod +x aleominer
    COMMAND="./aleominer -u stratum+ssl://aleo-asia.f2pool.com:4420 -d $DEVICES -w $MACHINE_NAME"
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
    wget -O aleo_prover-v0.2.3_full.tar.gz https://github.com/6block/zkwork_aleo_gpu_worker/releases/download/v0.2.3/aleo_prover-v0.2.3_full.tar.gz
    if [ $? -ne 0 ]; then
        echo "Failed to download Aleo Prover"
        exit 1
    fi
    tar -vxf aleo_prover-v0.2.3_full.tar.gz    
    cd /root/aleo_prover
    COMMAND="./aleo_prover --pool aleo.asia1.zk.work:10003 --pool aleo.hk.zk.work:10003 --pool aleo.jp.zk.work:10003 --address aleo16vqvtd0kr2fupv5rahhxw3hfyc9dc63k6447lee7z4y5ezp4gqys6un25m --custom_name $MACHINE_NAME"
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

# Function to run Oula Prover
run_oula_prover() {
    wget -O oula-pool-prover https://github.com/oula-network/aleo/releases/download/v1.12/oula-pool-prover
    if [ $? -ne 0 ]; then
        echo "Failed to download Oula Prover"
        exit 1
    fi
    chmod +x oula-pool-prover
    COMMAND="./oula-pool-prover --pool wss://aleo.oula.network:6666 --account akcha --worker-name $MACHINE_NAME"
    echo "Running command: $COMMAND"
    while true; do
        $COMMAND
        if [ $? -ne 0 ]; then
            echo "Oula Prover has exited, restarting..."
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
elif [ "$1" == "oula" ]; then
    run_oula_prover
else
    echo "Usage: $0 {f2|zk|oula}"
    exit 1
fi
