#!/bin/sh
################################################################# 
# basic-pitch:8GiB
#################################################################

# 開始時間
start_time=`date +%s`

# テスト用(60秒動画)
VIDEO_ID=ItRRrZIjCe4

# Youtubeダウンロード処理
echo "【yt-dlp】"
yt-dlp https://www.youtube.com/watch?v=${VIDEO_ID} -x --audio-format wav -o "/tmp/${VIDEO_ID}.%(ext)s"

# メロディーフレーズをMIDI/CSVに変換
echo "【basic-pitch】"
basic-pitch --save-note-events /tmp /tmp/${VIDEO_ID}.wav

# ファイル名を変更
mv /tmp/${VIDEO_ID}_basic_pitch.mid /tmp/${VIDEO_ID}.mid

# CSV解析
echo "【csv_analyze.py】"
python /app/python/csv_analyze.py ${VIDEO_ID}

# 変換後CSVを表示
CSV_FILE="/tmp/${VIDEO_ID}.csv"
cat $CSV_FILE

# ファイル削除
rm -rf /tmp/*

end_time=`date +%s`
run_time=$((end_time - start_time))
echo "テスト完了【${VIDEO_ID}】"
echo "実行時間【${run_time}秒】"