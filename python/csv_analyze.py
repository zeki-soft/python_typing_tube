import sys
import os
import csv
from operator import itemgetter

# コマンドライン引数(Youtube動画ID)
args = sys.argv
youtubeID = args[1]

# 作業ディレクトリ
os.chdir('/tmp')

# CSVファイル指定
csvFilePath = '/tmp/' + youtubeID + '_basic_pitch.csv'

# リスト初期化
csvList = []

# CSVファイル読み込み
with open (csvFilePath, 'r') as f:
    reader = csv.reader( f )
    # ヘッダー行をスキップ
    next(reader)
    for line in reader:
        # 行単位で表示
        start_time = round(float(line[0]), 3)
        end_time = round(float(line[1]), 3)
        pitch = int(line[2])
        velocity = int(line[3])
        csvList.append((start_time, end_time, pitch, velocity))

# 抽出したCSVリストをソート(start_time昇順)
csvList.sort(key=itemgetter(0))

# 出力ファイルに書き込み
out_file = open('/tmp/' + youtubeID + '.csv', 'w', encoding='UTF-8')
for i, time in enumerate(csvList):
    # CSV形式で出力
    out_file.writelines(str(time[0]) + ',' + str(time[1]) + ',' + str(time[2]) + ',' + str(time[3]))
    if i != len(csvList) - 1:
        # 最終以外は改行
        out_file.writelines('\n')
