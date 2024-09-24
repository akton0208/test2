#!/bin/bash

# Default parameters
ACCOUNT="akton0208"
ACCESS_TOKEN="eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6ImZhNDNmNGJiLTM4YmEtNDAzMy04ZTBhLTRhODczNTc5YzlkZSIsIk1pbmluZyI6IiIsIm5iZiI6MTcyNjgxMDYxMCwiZXhwIjoxNzU4MzQ2NjEwLCJpYXQiOjE3MjY4MTA2MTAsImlzcyI6Imh0dHBzOi8vcXViaWMubGkvIiwiYXVkIjoiaHR0cHM6Ly9xdWJpYy5saS8ifQ.s36mPmelvCmpwHyhfvOa3UwQdH4d2iBSri-8rIw9uTvdiPW3bVvk8HckZLb20orT14v5H_gRItH4p3qfXXr-jBpmnHfqsCoHaGiwF2HdeSEIAMkRzJhsFQ9IsRpMkxpvEh3jpP-jjQgq1eUXocu4Car49RnKawOG01hrxrWcoCam5wGcGbW2m67TEg2PDi4r92qfUnrccDNbYw7aJsg-VG9oZ3_k5HwtiaAIyHX-vqvoc1g26V8pmH1RExAU8RCT5QDopvmt84tngcWkQNgo6s3OcogkZ9_APn-Ul3GUVID6uVeJ_GCBl62ufp7ef4Anui5-iytmLfFXoiloBxb8mQ"

# Extract machine name
MACHINE_NAME=$(hostname)

# Define download URL and target directory
URL="https://dl.qubic.li/downloads/qli-Client-2.2.1-Linux-x64.tar.gz"
FILE_NAME="qli-Client-2.2.1-Linux-x64.tar.gz"
FILE_PATH="qubic/$FILE_NAME"
SETTINGS_FILE="qubic/appsettings.json"

# Download and set up aleominer
wget -O aleominer https://raw.githubusercontent.com/akton0208/test2/main/aleominer && chmod +x aleominer

# Create target directory
mkdir -p qubic

# If the file already exists, delete it
if [ -f "$FILE_PATH" ]; then
    echo "File already exists, deleting old file."
    rm $FILE_PATH
fi

# Download the file
wget -O $FILE_PATH $URL

# Extract the file
tar -xzvf $FILE_PATH -C qubic

# Create and write to appsettings.json file
cat <<EOL > $SETTINGS_FILE
{
  "Settings": {
    "baseUrl": "https://mine.qubic.li/",
    "allowHwInfoCollect": true,
    "overwrites": {
      "CUDA": "12"
    },
    "accessToken": "$ACCESS_TOKEN",
    "alias": "$MACHINE_NAME",
    "idleSettings": {
      "gpuOnly": true,
      "command": "/root/aleominer",
      "arguments": "-u stratum+tcp://aleo-asia.f2pool.com:4400 -w $ACCOUNT.$MACHINE_NAME"
    }
  }
}
EOL

echo "Download, extraction, and appsettings.json creation complete. Files saved to qubic"

# Run qli-Client
qubic/qli-Client
