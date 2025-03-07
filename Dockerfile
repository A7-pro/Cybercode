FROM ubuntu:22.04

# تحديث النظام وتثبيت المتطلبات الأساسية
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
      lua5.3 \
      luarocks \
      redis-server \
      curl \
      python3 \
      python3-pip \
      git \
      unzip \
      wget \
      libssl-dev \
      liblua5.3-dev \
      build-essential \
      gcc \
      make \
      pkg-config \
      libreadline-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# ضبط متغيرات البيئة لمسارات المكتبات
ENV LUA_INCDIR=/usr/include/lua5.3
ENV OPENSSL_INCDIR=/usr/include/openssl
ENV OPENSSL_LIBDIR=/usr/lib/x86_64-linux-gnu
ENV PATH="/usr/local/bin:$PATH"

# تثبيت مكتبات Lua عبر luarocks مع تحديد إصدار Lua 5.3 واستخدام المسارات الثابتة لـ OpenSSL
RUN luarocks install luasocket --lua-version=5.3 && \
    luarocks install luasec 0.8-1 --lua-version=5.3 OPENSSL_LIBDIR=/usr/lib/x86_64-linux-gnu OPENSSL_INCDIR=/usr/include/openssl && \
    luarocks install redis-lua --lua-version=5.3 && \
    luarocks install dkjson --lua-version=5.3

# تثبيت مكتبات Python المطلوبة
RUN pip3 install --no-cache-dir --upgrade pip setuptools wheel && \
    pip3 install flask gunicorn

# تعيين مجلد العمل
WORKDIR /app

# نسخ جميع الملفات المطلوبة إلى الحاوية
COPY . /app

# إعطاء صلاحيات التنفيذ لملف start.lua
RUN chmod +x /app/start.lua

# تشغيل Redis ثم تشغيل البوت
CMD ["bash", "-c", "redis-server --daemonize yes && lua /app/start.lua"]