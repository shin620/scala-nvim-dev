# ベースイメージを選択 (例: Ubuntu)
FROM ubuntu:24.04

# 必要なツールをインストール
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    openjdk-11-jdk \
    scala \
    python3 \
    python3-pip \
    neovim \
    && apt-get clean

# Node.js をインストール
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs

# Scalaのビルドツール sbt をインストール
RUN echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" > /etc/apt/sources.list.d/sbt.list && \
    curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x99E82A75642AC823" | gpg --dearmor > /usr/share/keyrings/sbt-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/sbt-archive-keyring.gpg] https://repo.scala-sbt.org/scalasbt/debian all main" > /etc/apt/sources.list.d/sbt.list && \
    apt-get update && apt-get install -y sbt && \
    apt-get clean

# Neovim用のプラグインマネージャをインストール
RUN curl -fLo /root/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Neovimの設定ファイルを追加
RUN mkdir -p /root/.config/nvim
COPY init.vim /root/.config/nvim/init.vim

# PlugInstallを実行してプラグインをインストール
RUN nvim --headless +PlugInstall +qall

# Scala Language Server (metals) をインストール
RUN curl -fLo /usr/local/bin/coursier \
    https://git.io/coursier-cli && \
    chmod +x /usr/local/bin/coursier && \
    coursier install metals && \
    mkdir -p /usr/local/bin && \
    mv /root/.local/share/coursier/bin/metals /usr/local/bin/metals

# Scalaプロジェクト用のディレクトリを準備
WORKDIR /workspace

CMD ["nvim"]

