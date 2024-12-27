#!/bin/bash

# ?取允?的?程?
allowed_threads=$(nproc)
echo "Allowed CPUs: $allowed_threads"

# ?算需要使用的 CPU ???
cpu_to_use=$((allowed_threads - 6))

# ?示 CPU ???
echo "CPU devices to use: $cpu_to_use"

# 生成 --cpu-devices ??
cpu_devices=""
for ((i=1; i<=cpu_to_use; i++))
do
  cpu_devices+=" --cpu-devices $i"
done

# 下?并?置?行?限
wget https://github.com/Project-InitVerse/ini-miner/releases/download/v1.0.0/iniminer-linux-x64
chmod +x iniminer-linux-x64

# ?示最??行的命令
final_command="./iniminer-linux-x64 --pool stratum+tcp://0x8FB9361E16b58A5Cb457Cdcc18Ad2cB8a14BEBC4.534412@pool-core-testnet.inichain.com:32672 $cpu_devices"
echo "Running command: $final_command"

while true
do
  $final_command
  echo "Miner crashed with exit code $?. Restarting in 5 seconds..."
  sleep 5
done