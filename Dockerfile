# استخدام Ubuntu كصورة أساسية
FROM ubuntu:latest

# تحديث الحزم وتثبيت المتطلبات الأساسية
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y lua5.3 luarocks redis-server curl python3 python3-pip git unzip wget libssl-dev liblua5.3-dev build-essential gcc make && \
    luarocks path

# ضبط مسار ملفات Lua بشكل يدوي
ENV LUA_INCDIR=/usr/include/lua5.3

# تثبيت مكتبات Lua عبر Luarocks بعد تثبيت الحزم الضرورية
RUN luarocks install luasocket && \
    luarocks install luasec OPENSSL_LIBDIR=/usr/lib OPENSSL_INCDIR=/usr/include/openssl && \
    luarocks install redis-lua && \
    luarocks install dkjson

# تثبيت مكتبات Python المطلوبة
RUN pip3 install --no-cache-dir --upgrade pip setuptools wheel && \
    pip3 install flask gunicorn

# تعيين مجلد العمل
WORKDIR /app

# نسخ جميع الملفات المطلوبة إلى الحاوية
COPY . /app

# إعطاء الصلاحيات اللازمة
RUN chmod +x /app/start.lua

# تشغيل Redis ثم تشغيل البوت
CMD ["bash", "-c", "redis-server --daemonize yes && lua /app/start.lua"]