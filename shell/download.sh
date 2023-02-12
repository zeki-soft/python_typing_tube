#!/bin/sh
################################################################# 
# curl:8GiB
# basic-pitch:8GiB
# 合計16GiB
#################################################################


# 引数チェック
if [ $# -lt 1 ]; then
    echo "引数に接続先ドメインを指定してください。"
    exit 1
fi

# 開始時間
start_time=`date +%s`

# 接続先URL
URL=$1

# ダウンロード対象を選択
if [ -z "$2" ]; then
    VIDEO_ID=`curl -X POST ${URL}/python/search`
else
    VIDEO_ID=$2
fi

if [ -z "${VIDEO_ID}" ]; then
    echo '対象なしのため終了'
    exit 1
else
    echo "VIDEO ID【${VIDEO_ID}】"
fi

# Youtubeダウンロード処理
yt-dlp https://www.youtube.com/watch?v=${VIDEO_ID} -x --audio-format wav -o "/tmp/${VIDEO_ID}.%(ext)s"

# メロディーフレーズを(midi/csv)に変換
basic-pitch --save-note-events /tmp /tmp/${VIDEO_ID}.wav

# ファイル名を変更
mv /tmp/${VIDEO_ID}_basic_pitch.mid /tmp/${VIDEO_ID}.mid

# CSV解析
python /app/python/csv_analyze.py ${VIDEO_ID}

end_time=`date +%s`
run_time=$((end_time - start_time))

# ファイルをアップロード
curl -X POST -F "videoid=${VIDEO_ID}" -F "time=${run_time}" -F "midiFile=@/tmp/${VIDEO_ID}.mid" -F "csvFile=@/tmp/${VIDEO_ID}.csv" "${URL}/python/upload"

# ファイル削除
rm -rf /tmp/*

end_time=`date +%s`
run_time=$((end_time - start_time))
echo "実行時間【${VIDEO_ID}】【${run_time}秒】"