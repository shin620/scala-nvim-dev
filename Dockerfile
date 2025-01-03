# ベースイメージを選択
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
    ripgrep \
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

# Lua設定ファイルを追加
RUN mkdir -p /root/.config/nvim/lua/config
COPY nvim_tree.lua /root/.config/nvim/lua/config/nvim_tree.lua
COPY telescope.lua /root/.config/nvim/lua/config/telescope.lua

# PlugInstallを実行してプラグインをインストール
RUN nvim --headless +PlugInstall +qall

# Coc.nvim 用の拡張機能をインストール
RUN mkdir -p ~/.config/coc/extensions && \
    cd ~/.config/coc/extensions && \
    echo '{"dependencies": {"coc-metals": "latest"}}' > package.json && \
    npm install --legacy-peer-deps --omit=dev --ignore-scripts --no-package-lock --no-bin-links

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

