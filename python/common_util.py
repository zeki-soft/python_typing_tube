# レベル算出
def calcLevel(list):
    
    start_time = list[0]    # 先頭ノート時間
    end_time = list[-1]     # 最終ノート時間
    note_cnt = len(list)    # ノート数

    # 60秒あたりのノート数
    notes = int((note_cnt / (end_time - start_time)) * 60.0)
    
    if note_cnt < 50:
        # ノート数50未満は対象外
        return -1
    elif notes <= 40:
        # // 60秒あたりノート数40未満
        return 1
    else:
        # ノート数が20上がるごとにレベル1上げる
        level = (float(notes - 40) / 20.0)
        return round(level, 1);

# CSVから譜面リストを出力
def outTimeList(csvList, diff_time):
    
    # 出力用リスト
    timeList = []

    for item in csvList:
        start_time = item[0]
        end_time = item[1]
        if end_time - start_time >= diff_time :
            timeList.append(start_time)
    
    # 重複削除
    timeList = list(dict.fromkeys(timeList))

    # 昇順ソート
    timeList.sort()

    return timeList