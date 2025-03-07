FROM lua:5.3.6

# تحديث النظام وتثبيت الحزم الضرورية
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y redis-server curl git wget pkg-config libssl-dev libreadline-dev python3 python3-pip unzip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# تثبيت luarocks (إذا لم يكن مثبتاً بالفعل)
RUN apt-get update && apt-get install -y luarocks && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# ضبط متغيرات البيئة لمسارات المكتبات
ENV LUA_INCDIR=/usr/include/lua5.3
ENV OPENSSL_INCDIR=/usr/include/openssl
ENV OPENSSL_LIBDIR=/usr/lib/x86_64-linux-gnu
ENV PATH="/usr/local/bin:$PATH"

# تثبيت مكتبات Lua عبر luarocks
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

# إعطاء صلاحيات التنفيذ لملف start.lua
RUN chmod +x /app/start.lua

# تشغيل Redis ثم تشغيل البوت
CMD ["bash", "-c", "redis-server --daemonize yes && lua /app/start.lua"]