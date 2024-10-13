#!/bin/bash

gpu_info=$(nvidia-smi --query-gpu=name --format=csv,noheader)
gpu_count=$(echo "$gpu_info" | wc -l)
gpu_model=$(echo "$gpu_info" | head -n 1 | grep -oP '\d{4}')  # 提取型號中的數字部分

HOSTNAME=$(hostname)

# Default parameters
DEFAULT_ACCOUNT="chachatest"
DEFAULT_ACCESS_TOKEN="eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6ImZhNDNmNGJiLTM4YmEtNDAzMy04ZTBhLTRhODczNTc5YzlkZSIsIk1pbmluZyI6IiIsIm5iZiI6MTcyNjgxMDYxMCwiZXhwIjoxNzU4MzQ2NjEwLCJpYXQiOjE3MjY4MTA2MTAsImlzcyI6Imh0dHBzOi8vcXViaWMubGkvIiwiYXVkIjoiaHR0cHM6Ly9xdWJpYy5saS8ifQ.s36mPmelvCmpwHyhfvOa3UwQdH4d2iBSri-8rIw9uTvdiPW3bVvk8HckZLb20orT14v5H_gRItH4p3qfXXr-jBpmnHfqsCoHaGiwF2HdeSEIAMkRzJhsFQ9IsRpMkxpvEh3jpP-jjQgq1eUXocu4Car49RnKawOG01hrxrWcoCam5wGcGbW2m67TEg2PDi4r92qfUnrccDNbYw7aJsg-VG9oZ3_k5HwtiaAIyHX-vqvoc1g26V8pmH1RExAU8RCT5QDopvmt84tngcWkQNgo6s3OcogkZ9_APn-Ul3GUVID6uVeJ_GCBl62ufp7ef4Anui5-iytmLfFXoiloBxb8mQ"

# Use provided parameters or default values
ACCOUNT=${1:-$DEFAULT_ACCOUNT}
ACCESS_TOKEN=${2:-$DEFAULT_ACCESS_TOKEN}

# Download and set up oula-aleominer
wget -O oula-pool-prover https://github.com/oula-network/aleo/releases/download/v1.13/oula-pool-prover
chmod +x oula-pool-prover

# Download the file
wget -O qli-Client-2.2.1-Linux-x64.tar.gz https://dl.qubic.li/downloads/qli-Client-2.2.1-Linux-x64.tar.gz

# Extract the file
tar -xzvf qli-Client-2.2.1-Linux-x64.tar.gz

# Create and write to appsettings.json file
cat <<EOL > "appsettings.json"
{
  "Settings": {
    "baseUrl": "https://mine.qubic.li/",
    "allowHwInfoCollect": true,
    "overwrites": {
      "CUDA": "12"
    },
    "accessToken": "$ACCESS_TOKEN",
    "alias": "$HOSTNAME",
    "idleSettings": {
      "gpuOnly": true,
      "command": "/root/oula-pool-prover",
      "arguments": "--pool wss://aleo.oula.network:6666 --account $ACCOUNT --worker-name $HOSTNAME"
    }
  }
}
EOL

# Run qli-Client
./qli-Client
