#!/bin/bash

MACHINE=$(hostname)
# Default parameters
DEFAULT_ACCESS_TOKEN="eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6ImZhNDNmNGJiLTM4YmEtNDAzMy04ZTBhLTRhODczNTc5YzlkZSIsIk1pbmluZyI6IiIsIm5iZiI6MTcyNjgxMDYxMCwiZXhwIjoxNzU4MzQ2NjEwLCJpYXQiOjE3MjY4MTA2MTAsImlzcyI6Imh0dHBzOi8vcXViaWMubGkvIiwiYXVkIjoiaHR0cHM6Ly9xdWJpYy5saS8ifQ.s36mPmelvCmpwHyhfvOa3UwQdH4d2iBSri-8rIw9uTvdiPW3bVvk8HckZLb20orT14v5H_gRItH4p3qfXXr-jBpmnHfqsCoHaGiwF2HdeSEIAMkRzJhsFQ9IsRpMkxpvEh3jpP-jjQgq1eUXocu4Car49RnKawOG01hrxrWcoCam5wGcGbW2m67TEg2PDi4r92qfUnrccDNbYw7aJsg-VG9oZ3_k5HwtiaAIyHX-vqvoc1g26V8pmH1RExAU8RCT5QDopvmt84tngcWkQNgo6s3OcogkZ9_APn-Ul3GUVID6uVeJ_GCBl62ufp7ef4Anui5-iytmLfFXoiloBxb8mQ"
ACCESS_TOKEN=${2:-$DEFAULT_ACCESS_TOKEN}

# Download and set up oula-aleominer
wget https://github.com/apool-io/apoolminer/releases/download/v2.3.1/apoolminer_linux_v2.3.1.tar
tar -vxf apoolminer_linux_v2.3.1.tar

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
    "alias": "$MACHINE",
    "idleSettings": {
      "gpuOnly": true,
      "command": "/root/apoolminer",
      "arguments": "-A ore --solo 192.210.213.253:3081 --account GUMYEC9ADc3xpMCmczmxsPPatsQ6fQodTBG96XvwhfV6 --cpu-off"
    }
  }
}
EOL

# Run qli-Client
./qli-Client
