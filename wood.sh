#!/bin/bash

# 檢查是否提供了 --rpc 和 --key 參數
if [ -z "$1" ] || [ -z "$2" ]; then
  echo "請提供 --rpc 和 --key 參數，例如：./wood.sh --rpc RPC --key YOUR_KEY"
  exit 1
fi

# 提取參數值
RPC_URL=$1
KEY=$2

# 更新軟件包列表
sudo apt update

# 安裝 cargo
sudo apt install cargo -y

# 安裝 screen
sudo apt install screen -y

# 安裝 openssl, pkg-config 和 libssl-dev
sudo apt-get install openssl pkg-config libssl-dev -y

# 使用 cargo 安裝 coal-cli
cargo install coal-cli

# 進入 .cargo/bin 目錄
cd ~/.cargo/bin

# 在 /root 下創建 id.json 並寫入 key
echo "$KEY" > /root/id.json

# 執行 coal mine 命令
./coal mine --resource wood --cores $(nproc) --keypair /root/id.json $RPC_URL --priority-fee 500
