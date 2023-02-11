import sys
import os
import librosa

# コマンドライン引数(Youtube動画ID)
args = sys.argv
youtubeID = args[1]

# 作業ディレクトリ
os.chdir('/tmp')

# mp3読み込み
y, sr = librosa.load('/tmp/' + youtubeID + '.wav')

# テンポとビートの抽出
bpm, beat_frames = librosa.beat.beat_track(y=y, sr=sr)

# ビートのタイミングを時間に変換
beat_times = librosa.frames_to_time(beat_frames, sr=sr)

# 出力ファイルを開く
f = open('/tmp/' + youtubeID + '_bpm.txt', 'w', encoding='UTF-8')

# ファイル出力
for i, time in enumerate(beat_times):
    t = round(time, 3)
    if i == len(beat_times) - 1:
        # 最終行のみ
        f.writelines(str(t))
    else:
        f.writelines(str(t) + '\n')

# ファイルを閉じる
f.close()