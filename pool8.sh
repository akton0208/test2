#!/bin/bash

HOSTNAME=$(hostname)

pkill -f ore-mine-pool-linux

# Download ore-mine-pool-linux
wget -O ore-mine-pool-linux https://raw.githubusercontent.com/akton0208/test2/main/ore-mine-pool-linux
if [ $? -ne 0 ]; then
    echo "Failed to download ore-mine-pool-linux"
    exit 1
fi

# Grant execute permission
chmod +x ore-mine-pool-linux

# Default wallet address
default_wallet_address="37BgmeJABVhQe9xzuG7UdD6Dy2QF7UAj2Yv7pY37yqwX"

# Check if a wallet address is provided, otherwise use the default address
wallet_address=${1:-$default_wallet_address}

# Function to get allowed threads
get_allowed_threads() {
  allowed_threads=$(nproc)
  echo "Allowed CPUs: $allowed_threads"
}

# Function to count running worker processes
count_running_workers() {
  pgrep -f 'ore-mine-pool-linux worker' | wc -l
}

# Get initial allowed threads
get_allowed_threads

# Calculate the number of threads to use (total threads - 8)
total_threads=$(nproc)
threads_to_use=$((total_threads - 8))

# Function to start the mining process
start_mining() {
  taskset -c 0-$((threads_to_use - 1)) ./ore-mine-pool-linux worker --route-server-url 'http://47.254.182.83:8080/' --server-url direct --worker-wallet-address $wallet_address --alias $MACHINE
}

# Main loop to keep the mining process running
while true; do
  start_mining
  if [ $? -ne 0 ]; then
    echo "Mining process stopped unexpectedly. Restarting..."
  fi
  sleep 5
done
