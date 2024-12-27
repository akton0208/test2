#!/bin/bash

wget https://github.com/Project-InitVerse/ini-miner/releases/download/v1.0.0/iniminer-linux-x64
chmod +x iniminer-linux-x64

while true
do
  ./iniminer-linux-x64 --pool stratum+tcp://0x4890d518Fea7BD57F0Cca70b9c381b1ef733189c.534412@pool-core-testnet.inichain.com:32672
  echo "Miner crashed with exit code $?. Restarting in 5 seconds..."
  sleep 5
done
