# ベースイメージとして Ubuntu 22.04 を使用
FROM ubuntu:22.04

# タイムゾーンと非対話型モードの設定
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo

# 必要なパッケージをインストール
RUN apt-get update && \
    apt-get install -y \
    curl \
    gnupg \
    ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# NodeSource リポジトリを追加して Node.js をインストール
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# npm のグローバルパス設定（sudo 不要でグローバルパッケージをインストール可能にする）
RUN mkdir -p ~/.npm-global && \
    npm config set prefix '~/.npm-global' && \
    echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc && \
    export PATH=~/.npm-global/bin:$PATH

# claude コマンドをインストール
RUN npm install -g @anthropic-ai/claude-code

# 作業ディレクトリを設定
WORKDIR /app

# コンテナ起動時に bash を実行
CMD ["bash"]
