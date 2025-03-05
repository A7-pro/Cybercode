# استخدم صورة Lua الأساسية
FROM ubuntu:latest

# تحديث النظام وتثبيت المتطلبات
RUN apt-get update && apt-get install -y \
    lua5.3 \
    luarocks \
    redis-server \
    git \
    curl

# تثبيت مكتبات Lua المطلوبة
RUN luarocks install luasocket && \
    luarocks install luasec && \
    luarocks install redis-lua && \
    luarocks install dkjson

# تحديد مجلد العمل
WORKDIR /app

# نسخ الملفات إلى الحاوية
COPY . /app

# إعطاء الصلاحيات لملف التشغيل
RUN chmod +x start.sh

# تشغيل Redis في الخلفية ثم تشغيل البوت
CMD ["/bin/bash", "-c", "redis-server --daemonize yes && lua cybercode.lua"]
