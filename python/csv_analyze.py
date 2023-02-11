import sys
import os
import csv
from operator import itemgetter

# 定数定義
MIN_PITCH = 48
MAX_PITCH = 72
MIN_VELOCITY = 50

# コマンドライン引数(Youtube動画ID)
args = sys.argv
youtubeID = args[1]

# 作業ディレクトリ
os.chdir('/tmp')

# CSVファイル指定
csvFilePath = '/tmp/' + youtubeID + '.csv'

# リスト初期化
csvList = []
timeList = []

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
        # 条件を満たすノートのみ抽出
        if MIN_PITCH <= pitch <= MAX_PITCH and velocity >= 50 :
            csvList.append((start_time, end_time))

# 抽出したCSVリストをソート(start_time昇順)
csvList.sort(key=itemgetter(0))

# ノートチェック
def checkNote(t):
    for item in csvList:
        start_time = item[0]
        end_time = item[1]
        if start_time <= t and t <= end_time:
            # 対象ノートあり
            return start_time
    
    # 対象ノートなし
    return 0

# BPMファイルをベースに対象ノートを抽出
with open('/tmp/' + youtubeID + '_bpm.txt') as f:
    for line in f:
        start_time = checkNote(float(line))
        if start_time > 0 :
            # 対象ノートを出力
            timeList.append(start_time)

# 重複削除
timeList = list(dict.fromkeys(timeList))

# 昇順ソート
timeList.sort()

# 出力ファイルに書き込み
out_file = open('/tmp/' + youtubeID + '.txt', 'w', encoding='UTF-8')
for i, time in enumerate(timeList):
    if i == len(timeList) - 1:
        # 最終行のみ
        out_file.writelines(str(time))
    else:
        out_file.writelines(str(time) + ',')
