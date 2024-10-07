#!/bin/bash

# 檢查是否提供了 --rpc 和 --key 參數
if [ -z "$1" ] || [ -z "$2" ]; then
  echo "參數不全，跳過創建 id.json 和執行 coal mine 命令"
else
  RPC_URL=$1
  KEY=$2

  # 在 /root 下創建 id.json 並寫入 key
  echo "$KEY" > /root/id.json

  # 執行 coal mine 命令
  ./coal mine --resource wood --cores $(nproc) --keypair /root/id.json --rpc $RPC_URL --priority-fee 500
fi

# 更新軟件包列表並安裝必要的軟件包
apt update && apt install -y sudo cargo screen openssl pkg-config libssl-dev

# 使用 cargo 安裝 coal-cli
cargo install coal-cli

# 進入 .cargo/bin 目錄
cd ~/.cargo/bin
