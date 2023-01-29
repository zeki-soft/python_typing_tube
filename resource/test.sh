#!/bin/sh

# 開始時間
start_time=`date +%s`

# テスト用
VIDEO_ID=ItRRrZIjCe4

# Youtubeダウンロード処理
echo "【yt-dlp】"
# yt-dlp https://www.youtube.com/watch?v=${VIDEO_ID} -x --audio-format mp3 -o "/tmp/${VIDEO_ID}.%(ext)s"
yt-dlp https://www.youtube.com/watch?v=${VIDEO_ID} -x --audio-format wav -o "/tmp/${VIDEO_ID}.%(ext)s"

# メロディーフレーズをMIDIに変換
echo "【basic-pitch】"
basic-pitch /tmp /tmp/${VIDEO_ID}.wav

# MIDIファイル名を変更
mv /tmp/${VIDEO_ID}_basic_pitch.mid /tmp/${VIDEO_ID}.mid

# MIDI解析(テキスト変換)
echo "【pretty.py】"
python /app/python/pretty.py ${VIDEO_ID} > /tmp/${VIDEO_ID}.txt

# 変換結果を表示
TXT_FILE="/tmp/${VIDEO_ID}.txt"
cat $TXT_FILE

# ファイル削除
rm -rf /tmp/*

end_time=`date +%s`
run_time=$((end_time - start_time))
echo "テスト完了【${VIDEO_ID}】"
echo "実行時間【${run_time}秒】"