#!/bin/sh

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
    VIDEO_ID=`curl -X POST ${URL}/rest/search`
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

# メロディーフレーズをMIDIに変換
basic-pitch /tmp /tmp/${VIDEO_ID}.wav

# MIDIファイル名を変更
mv /tmp/${VIDEO_ID}_basic_pitch.mid /tmp/${VIDEO_ID}.mid

# MIDI解析(テキスト変換)
python /app/python/pretty.py ${VIDEO_ID} > /tmp/${VIDEO_ID}.txt

# 変換結果を登録
MIDI_FILE="/tmp/${VIDEO_ID}.mid"
echo $MIDI_FILE

end_time=`date +%s`
run_time=$((end_time - start_time))

# ファイルをアップロード
curl -X POST -F "videoid=${VIDEO_ID}" -F "time=${run_time}" -F "midiFile=@/tmp/${VIDEO_ID}.mid" -F "textFile=@/tmp/${VIDEO_ID}.txt" "${URL}/rest/autoUpload"

# ファイル削除
rm -rf /tmp/*

end_time=`date +%s`
run_time=$((end_time - start_time))
echo "ダウンロード完了【${VIDEO_ID}】"
echo "実行時間【${run_time}秒】"