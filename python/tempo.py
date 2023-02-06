import sys
import os
import librosa
import numpy as np

# コマンドライン引数(Youtube動画ID)
args = sys.argv
fileName = args[1]

# 作業ディレクトリ
os.chdir('/tmp')

# mp3読み込み
y, sr = librosa.load('/tmp/' + fileName)

# テンポとビートの抽出
tempo, beat_frames = librosa.beat.beat_track(y=y, sr=sr)

# 音の強度
# onset_envelope = librosa.onset.onset_strength(y, sr=sr)

print('<tempo>')
print(tempo)
print('<beat_frames>')
print(beat_frames)
#print('<envelope>')
#print(onset_envelope)
