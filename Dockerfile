# استخدم Ubuntu كصورة أساسية
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
    libcurl4-openssl-dev

# تثبيت مكتبات Lua عبر Luarocks
RUN luarocks install luasocket && \
    luarocks install luasec OPENSSL_LIBDIR=/usr/lib/x86_64-linux-gnu OPENSSL_INCDIR=/usr/include/openssl && \
    luarocks install redis-lua && \
    luarocks install dkjson

# تعيين مجلد العمل
WORKDIR /app

# نسخ جميع الملفات
COPY . /app

# إعطاء الصلاحيات لملف التشغيل
RUN chmod +x start.sh

# تشغيل Redis ثم تشغيل البوت
CMD ["bash", "-c", "redis-server --daemonize yes && lua cybercode.lua"]
