#!/bin/bash

# Default wallet address
default_wallet_address="37BgmeJABVhQe9xzuG7UdD6Dy2QF7UAj2Yv7pY37yqwX"

# Check if a wallet address is provided, otherwise use the default address
wallet_address=${1:-$default_wallet_address}

# Automatically get the total number of threads available on the system
total_threads=$(nproc)
threads_per_task=96

# If the total number of threads is less than the threads required per task, use all available threads
if [ $total_threads -lt $threads_per_task ]; then
  threads_per_task=$total_threads
fi

# Calculate the number of tasks
num_tasks=$((total_threads / threads_per_task))
remaining_threads=$((total_threads % threads_per_task))

# Create tasks
for ((i=0; i<num_tasks; i++)); do
  taskset -c $((i * threads_per_task))-$(((i + 1) * threads_per_task - 1)) ./ore-mine-pool-linux worker --route-server-url 'http://47.254.182.83:8080/' --server-url direct --worker-wallet-address $wallet_address &
done

# If there are remaining threads, create the last task
if [ $remaining_threads -ne 0 ]; then
  taskset -c $((num_tasks * threads_per_task))-$((total_threads - 1)) ./ore-mine-pool-linux worker --route-server-url 'http://47.254.182.83:8080/' --server-url direct --worker-wallet-address $wallet_address &
fi

# Wait for all tasks to complete
wait
