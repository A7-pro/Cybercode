# استخدام Ubuntu كصورة أساسية
FROM ubuntu:latest

# تحديث الحزم وتثبيت جميع المتطلبات الأساسية
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y lua5.3 luarocks redis-server curl python3 python3-pip git unzip wget \
    libssl-dev liblua5.3-dev build-essential gcc make pkg-config libreadline-dev && \
    luarocks path

# ضبط متغيرات البيئة لمسارات المكتبات
ENV LUA_INCDIR=/usr/include/lua5.3
ENV OPENSSL_INCDIR=/usr/include/openssl
ENV OPENSSL_LIBDIR=/usr/lib/x86_64-linux-gnu
ENV PATH="/usr/local/bin:$PATH"

# تثبيت مكتبات Lua عبر Luarocks بعد ضبط المسارات
RUN luarocks install luasocket && \
    luarocks install luasec OPENSSL_LIBDIR=$OPENSSL_LIBDIR OPENSSL_INCDIR=$OPENSSL_INCDIR && \
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