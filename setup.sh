#!/bin/bash

# Get GPU model and count
gpu_info=$(nvidia-smi --query-gpu=name --format=csv,noheader)
gpu_count=$(echo "$gpu_info" | wc -l)
gpu_model=$(echo "$gpu_info" | head -n 1 | grep -oP '\d{4}')  # Extract the numeric part of the model

# Get the machine name and extract the last 8 digits
vastname=$(cat ~/.vast_containerlabel)
vastname_last8=$(echo "$vastname" | tail -c 9)  # Includes the preceding "_"

# Format as "countXmodel_hostname"
MACHINE="${gpu_count}X${gpu_model}_${vastname_last8}"
echo "MACHINE is set to: $MACHINE"  # Check the variable setting
export MACHINE

# Base URL and file list
BASE_URL="https://raw.githubusercontent.com/akton0208/test2/main/"
FILES=("aleof2.sh" "aleozk.sh" "f2q.sh" "aleooula.sh" "pool.sh" "oulaq.sh")

# Download and set up each file
for FILE in "${FILES[@]}"; do
    wget -O $FILE ${BASE_URL}${FILE}
    if [ $? -ne 0 ]; then
        echo "Failed to download $FILE"
        exit 1
    fi
    chmod +x $FILE
done

echo "Setup completed successfully on machine: $MACHINE"
