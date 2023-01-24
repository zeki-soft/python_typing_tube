import sys
import os
import pretty_midi

# トラックのノート情報出力
def outputNotes(notes):
    for note in notes:
        # ベロシティー、ノートナンバー、
        # ノートオンタイム、ノートオフタイム
        # の順でノート情報が渡される
        print(note)

# コマンドライン引数(Youtube動画ID)
args = sys.argv
youtubeID = args[1]

# 作業ディレクトリ
os.chdir('/tmp/' + youtubeID)

# MIDIファイルのロード
midi_data = pretty_midi.PrettyMIDI(youtubeID + '.mid')

# トラック別で取得
midi_tracks = midi_data.instruments

# トラック番号
trackNumber = 0

# トラック単位でノート情報を出力
for track in midi_tracks:
    # トラックのノート情報を出力
    print('TRACK:' + str(trackNumber))
    outputNotes(track.notes)
    trackNumber += 1