FROM ubuntu:22.04

# تحديث النظام وتثبيت المتطلبات الأساسية
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
      lua5.3 \
      luarocks \
      redis-server \
      curl \
      git \
      wget \
      libssl-dev \
      liblua5.3-dev \
      libconfig-dev \
      libjansson-dev \
      build-essential \
      libevent-dev \
      zlib1g-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# تثبيت Telegram CLI
RUN git clone --recursive https://github.com/vysheng/tg.git /tmp/tg && \
    cd /tmp/tg && \
    sed -i 's/-Werror//g' Makefile && \
    ./configure && make && \
    mv /tmp/tg/bin/telegram-cli /usr/local/bin/ && \
    rm -rf /tmp/tg

# ضبط متغيرات البيئة
ENV LUA_INCDIR=/usr/include/lua5.3
ENV PATH="/usr/local/bin:$PATH"

# تثبيت مكتبات Lua
RUN luarocks install luasocket --lua-version=5.3 && \
    luarocks install luasec --lua-version=5.3 OPENSSL_DIR=/usr && \
    luarocks install redis-lua --lua-version=5.3 && \
    luarocks install dkjson --lua-version=5.3

# تعيين مجلد العمل
WORKDIR /app

# نسخ الملفات
COPY . /app

# تشغيل Redis والبوت
CMD ["bash", "-c", "redis-server --daemonize yes && lua /app/start.lua"]