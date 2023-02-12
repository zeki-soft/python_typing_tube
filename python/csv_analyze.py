import sys
import os
import csv
import math
import common_util
import numpy as np
from operator import itemgetter

# 定数定義
MIN_PITCH = 36
MAX_PITCH = 96
MIN_VELOCITY = 40
TARGET_LEVEL = 4
MAX_LEVEL = 8.0
MIN_LEVEL = 1.0

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
        if MIN_PITCH <= pitch <= MAX_PITCH and velocity >= MIN_VELOCITY :
            csvList.append((start_time, end_time))

# 抽出したCSVリストをソート(start_time昇順)
csvList.sort(key=itemgetter(0))

# 0.05秒単位で対象外ノートを増やす
diff_time_list = np.arange(0.0, 1.0, 0.05)
for diff_time in diff_time_list:
    # 譜面とレベルを算出
    list = common_util.outTimeList(csvList, diff_time);
    level = common_util.calcLevel(list)
    if MIN_LEVEL <= level and level <= MAX_LEVEL :
        # レベル範囲内の場合
        timeList = list
        break
    elif level < 1.0:
        # 最小レベル以下はチェックふょう
        break

# 出力ファイルに書き込み
out_file = open('/tmp/' + youtubeID + '.txt', 'w', encoding='UTF-8')
for i, time in enumerate(timeList):
    if i == len(timeList) - 1:
        # 最終行のみ
        out_file.writelines(str(time))
    else:
        out_file.writelines(str(time) + ',')
