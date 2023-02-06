import sys
import os
import pydub

# コマンドライン引数(Youtube動画ID)
args = sys.argv
youtubeID = args[1]

# 作業ディレクトリ
os.chdir('/tmp/' + youtubeID)

# WAV→MP3変換
sound = pydub.AudioSegment.from_wav('piano.wav')
sound.export('piano.mp3', format='mp3')