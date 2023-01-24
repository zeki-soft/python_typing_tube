#!/bin/sh

# 開始時間
start_time=`date +%s`

# テスト用
VIDEO_ID=ItRRrZIjCe4

# Youtubeダウンロード処理
echo "【yt-dlp】"
yt-dlp https://www.youtube.com/watch?v=${VIDEO_ID} -x --audio-format mp3 -o "/tmp/${VIDEO_ID}.%(ext)s"

# 楽器パートを分離
echo "【spleeter】"
spleeter separate -p spleeter:5stems -o /tmp "/tmp/${VIDEO_ID}.mp3"

# 分離処理ができない場合はエラー
if [ ! -e "/tmp/${VIDEO_ID}" ]; then
    rm -rf /tmp/*
    echo "エラー【${VIDEO_ID}】"
    exit
fi

# WAV⇒MP3変換
echo "【pydub_mp3.py】"
python /app/python/pydub_mp3.py ${VIDEO_ID}

# ピアノ音源(MP3)を解析してMIDI変換
echo "【piano_convert.py】"
python /app/python/piano_convert.py ${VIDEO_ID}

# MIDI解析(テキスト変換)
echo "【pretty.py】"
python /app/python/pretty.py ${VIDEO_ID} > /tmp/${VIDEO_ID}/${VIDEO_ID}.txt

# 変換結果を表示
TXT_FILE="/tmp/${VIDEO_ID}/${VIDEO_ID}.txt"
cat $TXT_FILE

# ファイル削除
rm -rf /tmp/*

end_time=`date +%s`
run_time=$((end_time - start_time))
echo "テスト完了【${VIDEO_ID}】"
echo "実行時間【${run_time}秒】"