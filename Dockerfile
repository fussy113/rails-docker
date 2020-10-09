FROM centos:latest

# 各環境変数を設定
ARG USER=docker
ARG PASSWD=docker
ARG RUBY_VERSION=2.7.2
ENV SHELL /bin/bash

RUN yum -y update && \
    yum -y install sudo gcc-c++ make git bzip2 postgresql postgresql-devel openssl-devel @nodejs:12/common && \
    npm i -g yarn

# ユーザーアカウントを追加
RUN echo "$USER ALL=(ALL) ALL" >> /etc/sudoers && \
    echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
    useradd -m $USER -g wheel && \
    chown docker:wheel /home/$USER

USER $USER
WORKDIR /home/$USER

# rubyのインストール
RUN git clone https://github.com/sstephenson/rbenv.git ./.rbenv && \
    git clone https://github.com/sstephenson/ruby-build.git ./.rbenv/plugins/ruby-build

RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc && \
    echo 'eval "$(rbenv init -)"' >> ~/.bashrc

RUN source ./.bash_profile && \
    sudo ~/.rbenv/plugins/ruby-build/install.sh && \
    rbenv install $RUBY_VERSION && \
    rbenv global $RUBY_VERSION
