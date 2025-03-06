# استخدام Ubuntu كصورة أساسية
FROM ubuntu:latest

# تحديث الحزم وتثبيت المتطلبات الأساسية
RUN apt-get update && apt-get install -y \
    lua5.3 \
    luarocks \
    redis-server \
    git \
    curl \
    build-essential \
    liblua5.3-dev \
    libssl-dev \
    openssl \
    libcurl4-openssl-dev \
    unzip \
    wget

# تثبيت مكتبات Lua المطلوبة عبر Luarocks مع دعم OpenSSL
RUN luarocks install luasocket && \
    luarocks install luasec OPENSSL_DIR=/usr && \
    luarocks install redis-lua && \
    luarocks install dkjson

# تعيين مجلد العمل
WORKDIR /app

# نسخ جميع الملفات المطلوبة إلى الحاوية
COPY . /app

# تشغيل Redis ثم تشغيل البوت
CMD ["bash", "-c", "redis-server --daemonize yes && lua /app/start.lua"]
