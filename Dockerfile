FROM ubuntu:22.04

# تحديث النظام وتثبيت المتطلبات الأساسية
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
      lua5.3 \
      luarocks \
      redis-server \
      curl \
      python3 \
      python3-pip \
      git \
      unzip \
      wget \
      libssl-dev \
      liblua5.3-dev \
      libconfig-dev \
      libjansson-dev \
      build-essential \
      gcc \
      make \
      pkg-config \
      libreadline-dev \
      dnsutils \
      libevent-dev \
      zlib1g-dev \
      ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# تثبيت Telegram CLI
RUN git clone --recursive https://github.com/vysheng/tg.git /tmp/tg && \
    cd /tmp/tg && \
    sed -i 's/-Werror//g' Makefile && \
    ./configure && make && \
    mv /tmp/tg/bin/telegram-cli /usr/local/bin/ && \
    rm -rf /tmp/tg

# باقي الـ Dockerfile...