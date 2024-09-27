#!/bin/bash

# Default wallet address
default_wallet_address="37BgmeJABVhQe9xzuG7UdD6Dy2QF7UAj2Yv7pY37yqwX"

# Check if a wallet address is provided, otherwise use the default address
wallet_address=${1:-$default_wallet_address}

# Automatically get the total number of allowed threads
cpu_max=$(cat /sys/fs/cgroup/cpu.max)
cpu_quota=$(echo $cpu_max | awk '{print $1}')
cpu_period=$(echo $cpu_max | awk '{print $2}')
allowed_threads=$((cpu_quota / cpu_period))

threads_per_task=96

# If the total number of allowed threads is less than or equal to the threads required per task, run without taskset
if [ $allowed_threads -le $threads_per_task ]; then
  ./ore-mine-pool-linux worker --route-server-url 'http://47.254.182.83:8080/' --server-url direct --worker-wallet-address $wallet_address &
else
  # Calculate the number of tasks
  num_tasks=$((allowed_threads / threads_per_task))
  remaining_threads=$((allowed_threads % threads_per_task))

  # Create tasks
  for ((i=0; i<num_tasks; i++)); do
    taskset -c $((i * threads_per_task))-$(((i + 1) * threads_per_task - 1)) ./ore-mine-pool-linux worker --route-server-url 'http://47.254.182.83:8080/' --server-url direct --worker-wallet-address $wallet_address &
  done

  # If there are remaining threads, create the last task
  if [ $remaining_threads -ne 0 ]; then
    taskset -c $((num_tasks * threads_per_task))-$((allowed_threads - 1)) ./ore-mine-pool-linux worker --route-server-url 'http://47.254.182.83:8080/' --server-url direct --worker-wallet-address $wallet_address &
  fi
fi

# Wait for all tasks to complete
wait
