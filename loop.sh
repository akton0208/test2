#!/bin/bash

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

wget https://github.com/Project-InitVerse/ini-miner/releases/download/v1.0.0/iniminer-linux-x64
chmod +x iniminer-linux-x64

allowed_threads=$(get_allowed_threads)

cpu_to_use=$((allowed_threads - 6))

cpu_devices=""
for ((i=1; i<=cpu_to_use; i++))
do
  cpu_devices+=" --cpu-devices $i"
done

while true
do
  ./iniminer-linux-x64 --pool stratum+tcp://0x4890d518Fea7BD57F0Cca70b9c381b1ef733189c.534412@pool-core-testnet.inichain.com:32672 $cpu_devices
  echo "Miner crashed with exit code $?. Restarting in 5 seconds..."
  sleep 5
done
