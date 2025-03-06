# استخدام Ubuntu كصورة أساسية
FROM ubuntu:latest

# تحديث النظام وتثبيت الحزم الأساسية
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

# تثبيت مكتبات Lua المطلوبة عبر Luarocks
RUN luarocks install luasocket && \
    luarocks install luasec OPENSSL_LIBDIR=/usr/lib OPENSSL_INCDIR=/usr/include/openssl && \
    luarocks install redis-lua && \
    luarocks install dkjson

# تعيين مجلد العمل داخل الحاوية
WORKDIR /app

# نسخ جميع الملفات من مجلد المشروع إلى `/app` داخل الحاوية
COPY . /app

# إعطاء الصلاحيات لملف `start.lua`
RUN chmod +x /app/start.lua

# تشغيل Redis ثم تشغيل البوت
CMD ["bash", "-c", "redis-server --daemonize yes && lua /app/start.lua"]
