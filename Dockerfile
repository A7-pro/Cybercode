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
    libcurl4-openssl-dev \
    unzip \
    wget

# التحقق من وجود lua وتحديد الإصدار الصحيح
RUN ln -sf /usr/bin/lua5.3 /usr/bin/lua

# تنزيل وتثبيت LuaRocks يدويًا
RUN wget https://luarocks.org/releases/luarocks-3.9.2.tar.gz && \
    tar zxpf luarocks-3.9.2.tar.gz && \
    cd luarocks-3.9.2 && \
    ./configure --with-lua-include=/usr/include/lua5.3 && \
    make && make install

# تثبيت مكتبات Lua عبر Luarocks
RUN luarocks install luasocket && \
    luarocks install luasec && \
    luarocks install redis-lua && \
    luarocks install dkjson

# تعيين مجلد العمل
WORKDIR /app

# نسخ جميع الملفات إلى الحاوية
COPY . /app

# إعطاء الصلاحيات لملف التشغيل
RUN chmod +x start.sh

# تشغيل Redis ثم تشغيل البوت
CMD ["bash", "-c", "redis-server --daemonize yes && lua cybercode.lua"]
