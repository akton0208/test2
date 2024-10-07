#!/bin/bash

# 檢查是否提供了 --rpc 和 --key 參數
while getopts ":r:k:" opt; do
  case $opt in
    r) RPC_URL="$OPTARG"
    ;;
    k) KEY="$OPTARG"
    ;;
    \?) echo "無效的選項 -$OPTARG" >&2
        exit 1
    ;;
    :) echo "選項 -$OPTARG 需要一個參數" >&2
       exit 1
    ;;
  esac
done

# 檢查是否提供了必要的參數
if [ -z "$RPC_URL" ] || [ -z "$KEY" ]; then
  echo "請提供 --rpc 和 --key 參數，例如：./wood.sh -r RPC_URL -k YOUR_KEY"
  exit 1
fi

# 確保以 root 權限運行
if [ "$EUID" -ne 0 ]; then
  echo "請以 root 權限運行此腳本"
  exit 1
fi

# 更新軟件包列表並安裝必要的軟件包
apt update && apt install -y sudo cargo screen openssl pkg-config libssl-dev

# 使用 cargo 安裝 coal-cli
cargo install coal-cli

# 進入 .cargo/bin 目錄
cd ~/.cargo/bin

# 在 /root 下創建 id.json 並寫入 key
if [ -n "$KEY" ]; then
  echo "$KEY" > /root/id.json
fi

# 執行 coal mine 命令
if [ -n "$RPC_URL" ] && [ -n "$KEY" ]; then
  ./coal mine --resource wood --cores $(nproc) --keypair /root/id.json --rpc $RPC_URL --priority-fee 500
fi
