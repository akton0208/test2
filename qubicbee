#!/bin/bash


vastname=$(cat ~/.vast_containerlabel)
vastname_last8=$(echo "$vastname" | tail -c 9)  # 包括前面的 "_" 符號
MACHINE="${gpu_count}X${gpu_model}_${vastname_last8}"

# Default parameters
DEFAULT_ACCESS_TOKEN="eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6ImZhNDNmNGJiLTM4YmEtNDAzMy04ZTBhLTRhODczNTc5YzlkZSIsIk1pbmluZyI6IiIsIm5iZiI6MTcyNjgxMDYxMCwiZXhwIjoxNzU4MzQ2NjEwLCJpYXQiOjE3MjY4MTA2MTAsImlzcyI6Imh0dHBzOi8vcXViaWMubGkvIiwiYXVkIjoiaHR0cHM6Ly9xdWJpYy5saS8ifQ.s36mPmelvCmpwHyhfvOa3UwQdH4d2iBSri-8rIw9uTvdiPW3bVvk8HckZLb20orT14v5H_gRItH4p3qfXXr-jBpmnHfqsCoHaGiwF2HdeSEIAMkRzJhsFQ9IsRpMkxpvEh3jpP-jjQgq1eUXocu4Car49RnKawOG01hrxrWcoCam5wGcGbW2m67TEg2PDi4r92qfUnrccDNbYw7aJsg-VG9oZ3_k5HwtiaAIyHX-vqvoc1g26V8pmH1RExAU8RCT5QDopvmt84tngcWkQNgo6s3OcogkZ9_APn-Ul3GUVID6uVeJ_GCBl62ufp7ef4Anui5-iytmLfFXoiloBxb8mQ"

# Use provided parameters or default values
ACCOUNT=${1:-$DEFAULT_ACCOUNT}
ACCESS_TOKEN=${2:-$DEFAULT_ACCESS_TOKEN}
THREADS=$(nproc)

# Download and set up oula-aleominer
wget -O ore-mine-pool-linux https://raw.githubusercontent.com/akton0208/test2/main/ore-mine-pool-linux
chmod +x ore-mine-pool-linux

# Download the file
wget -O qli-Client-2.2.1-Linux-x64.tar.gz https://dl.qubic.li/downloads/qli-Client-2.2.1-Linux-x64.tar.gz

# Extract the file
tar -xzvf qli-Client-2.2.1-Linux-x64.tar.gz

# Create and write to appsettings.json file
cat <<EOL > "appsettings.json"
{
  "Settings": {
    "baseUrl": "https://mine.qubic.li/",
    "overwrites": {},
    "accessToken": "$ACCESS_TOKEN",
    "amountOfThreads": $THREADS,
    "alias": "$MACHINE",
    "idleSettings": {
      "command": "/root/beepool.sh",
      "arguments": ""
    }
  }
}
EOL

# Run qli-Client
./qli-Client
