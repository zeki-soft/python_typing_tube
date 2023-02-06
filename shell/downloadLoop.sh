#!/bin/sh

# 引数チェック
if [ $# != 1 ]; then
    echo "引数に接続先URLを指定してください。"
    exit 1
fi

while true
do
    # ダウンロード処理実行
    bash /app/shell/download.sh $1

    # ダウンロード対象が無くなるまで繰り返し
    if [ $? -eq 1 ]; then
        # ループ終了
        break
    fi
done
