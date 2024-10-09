#!/bin/bash

vastname=$(cat ~/.vast_containerlabel)
vastname_last8=$(echo "$vastname" | tail -c 9)  # 包括前面的 "_" 符號
MACHINE="${vastname_last8}"

# Default wallet address
default_wallet_address="37BgmeJABVhQe9xzuG7UdD6Dy2QF7UAj2Yv7pY37yqwX"

# Check if a wallet address is provided, otherwise use the default address
wallet_address=${1:-$default_wallet_address}

# Function to get allowed threads
get_allowed_threads() {
  if [ -f /sys/fs/cgroup/cpu/cpu.cfs_quota_us ]; then
    # cgroup v1
    cpu_quota=$(cat /sys/fs/cgroup/cpu/cpu.cfs_quota_us)
    cpu_period=$(cat /sys/fs/cgroup/cpu/cpu.cfs_period_us)
    allowed_threads=$((cpu_quota / cpu_period))
  elif [ -f /sys/fs/cgroup/cpu.max ]; then
    # cgroup v2
    cpu_max=$(cat /sys/fs/cgroup/cpu.max)
    cpu_quota=$(echo $cpu_max | awk '{print $1}')
    cpu_period=$(echo $cpu_max | awk '{print $2}')
    allowed_threads=$((cpu_quota / cpu_period))
  else
    # Default to total threads if no cgroup limits are found
    allowed_threads=$(nproc)
  fi
  echo "Allowed CPUs: $allowed_threads"
}

# Function to count running worker processes
count_running_workers() {
  pgrep -f 'ore-mine-pool-linux worker' | wc -l
}

# Get initial allowed threads
get_allowed_threads

# Start a background loop to echo allowed threads and running processes every 30 seconds
while true; do
  sleep 30
  get_allowed_threads
  running_workers=$(count_running_workers)
  echo "Running worker processes: $running_workers"
done &

threads_per_task=32

# If the total number of allowed threads is less than or equal to the threads required per task, run without taskset
if [ $allowed_threads -le $threads_per_task ]; then
  ./ore-mine-pool-linux worker --route-server-url 'http://47.254.182.83:8080/' --server-url direct --worker-wallet-address $wallet_address --alias $MACHINE &
else
  # Calculate the number of tasks
  num_tasks=$((allowed_threads / threads_per_task))
  remaining_threads=$((allowed_threads % threads_per_task))

  # Create tasks
  for ((i=0; i<num_tasks; i++)); do
    taskset -c $((i * threads_per_task))-$(((i + 1) * threads_per_task - 1)) ./ore-mine-pool-linux worker --route-server-url 'http://47.254.182.83:8080/' --server-url direct --worker-wallet-address $wallet_address --alias $MACHINE &
  done

  # If there are remaining threads, create the last task
  if [ $remaining_threads -ne 0 ]; then
    taskset -c $((num_tasks * threads_per_task))-$((allowed_threads - 1)) ./ore-mine-pool-linux worker --route-server-url 'http://47.254.182.83:8080/' --server-url direct --worker-wallet-address $wallet_address --alias $MACHINE &
  fi
fi

# Wait for all tasks to complete
wait
