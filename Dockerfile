FROM ubuntu:22.04

# 環境変数
ENV DEBIAN_FRONTEND noninteractive
RUN sed -i 's@archive.ubuntu.com@www.ftp.ne.jp/Linux/packages/ubuntu/archive@g' /etc/apt/sources.list

# モジュールコピー
RUN mkdir /app
COPY python/ /app/
COPY shell/ /app/
COPY resource/requirements.txt /tmp/

# コマンドアップデート
RUN apt-get update && apt-get install -y --no-install-recommends wget curl build-essential libreadline-dev \
libncursesw5-dev libssl-dev libsqlite3-dev libgdbm-dev libbz2-dev liblzma-dev zlib1g-dev uuid-dev libffi-dev libdb-dev

# Pythonインストール
WORKDIR /tmp
RUN wget --no-check-certificate https://www.python.org/ftp/python/3.8.0/Python-3.8.0.tgz \
&& tar -xf Python-3.8.0.tgz \
&& cd Python-3.8.0 \
&& ./configure --enable-optimizations\
&& make \
&& make install

# シンボリックリンク
RUN ln -s /usr/local/bin/python3.8 /usr/local/bin/python

# pipインストール
RUN wget --no-check-certificate https://bootstrap.pypa.io/get-pip.py
RUN python get-pip.py

# Pythonパッケージインストール
WORKDIR /tmp
RUN python3.8 -m pip install pip
RUN pip install --upgrade setuptools
RUN pip install -r requirements.txt

# ffmpegインストール
RUN apt update && apt install -y --no-install-recommends ffmpeg certbot
ENV TZ=Asia/Tokyo

# 不要ファイル削除
RUN apt-get autoremove -y
RUN rm -rf /tmp/*

# デプロイ疎通用の簡易サーバ起動
CMD ["python","/app/python/server.py"]