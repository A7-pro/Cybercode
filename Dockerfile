FROM ubuntu:22.04

# تحديث النظام وتثبيت المتطلبات الأساسية
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
      lua5.3 luarocks redis-server curl python3 python3-pip git unzip wget \
      libssl-dev liblua5.3-dev build-essential gcc make pkg-config libreadline-dev \
      dnsutils libevent-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# تثبيت Telegram CLI
RUN git clone --recursive https://github.com/vysheng/tg.git /tmp/tg && \
    cd /tmp/tg && \
    ./configure && make && \
    mv /tmp/tg/bin/telegram-cli /usr/local/bin/ && \
    rm -rf /tmp/tg

# ضبط متغيرات البيئة
ENV LUA_INCDIR=/usr/include/lua5.3
ENV PATH="/usr/local/bin:$PATH"

# تثبيت مكتبات Lua
RUN luarocks install luasocket --lua-version=5.3 && \
    luarocks install luasec 0.8-1 --lua-version=5.3 OPENSSL_DIR=/usr && \
    luarocks install redis-lua --lua-version=5.3 && \
    luarocks install dkjson --lua-version=5.3

# تثبيت مكتبات Python
RUN pip3 install --no-cache-dir --upgrade pip setuptools wheel && \
    pip3 install flask gunicorn

# تعيين مجلد العمل
WORKDIR /app

# نسخ الملفات
COPY . /app

# إعطاء صلاحيات التنفيذ
RUN chmod +x /app/Cybercode.lua

# تشغيل Redis والبوت
CMD ["bash", "-c", "redis-server --daemonize yes && until redis-cli ping; do sleep 1; done && lua /app/Cybercode.lua"]
