#!/bin/bash

# ?����?��?�{?
allowed_threads=$(nproc)
echo "Allowed CPUs: $allowed_threads"

# ?��ݭn�ϥΪ� CPU ???
cpu_to_use=$((allowed_threads - 6))

# ?�� CPU ???
echo "CPU devices to use: $cpu_to_use"

# �ͦ� --cpu-devices ??
cpu_devices=""
for ((i=1; i<=cpu_to_use; i++))
do
  cpu_devices+=" --cpu-devices $i"
done

# �U?�}?�m?��?��
wget https://github.com/Project-InitVerse/ini-miner/releases/download/v1.0.0/iniminer-linux-x64
chmod +x iniminer-linux-x64

# ?�ܳ�??�檺�R�O
final_command="./iniminer-linux-x64 --pool stratum+tcp://0x8FB9361E16b58A5Cb457Cdcc18Ad2cB8a14BEBC4.534412@pool-core-testnet.inichain.com:32672 $cpu_devices"
echo "Running command: $final_command"

while true
do
  $final_command
  echo "Miner crashed with exit code $?. Restarting in 5 seconds..."
  sleep 5
done