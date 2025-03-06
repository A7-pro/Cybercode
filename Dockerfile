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

# التأكد من استخدام Lua 5.3 كإصدار افتراضي
RUN ln -sf /usr/bin/lua5.3 /usr/bin/lua

# تنزيل وتثبيت LuaRocks يدويًا
RUN wget https://luarocks.org/releases/luarocks-3.9.2.tar.gz && \
    tar zxpf luarocks-3.9.2.tar.gz && \
    cd luarocks-3.9.2 && \
    ./configure --with-lua-include=/usr/include/lua5.3 && \
    make && make install

# تثبيت مكتبات Lua عبر Luarocks مع دعم OpenSSL
RUN luarocks install luasocket && \
    luarocks install luasec OPENSSL_LIBDIR=/usr/lib OPENSSL_INCDIR=/usr/include/openssl && \
    luarocks install redis-lua && \
    luarocks install dkjson

# تعيين مجلد العمل
WORKDIR /app

# نسخ جميع الملفات المطلوبة إلى الحاوية
COPY File_Libs /app/File_Libs
COPY start.lua /app/start.lua
COPY sudo.lua /app/sudo.lua
COPY tg /app/tg
COPY Cybercode.lua /app/Cybercode.lua
COPY Fastinstall.sh /app/Fastinstall.sh
COPY install.sh /app/install.sh
COPY render.yaml /app/render.yaml

# تشغيل Redis ثم تشغيل البوت
CMD bash -c "redis-server & sleep 2 && lua /app/start.lua"
