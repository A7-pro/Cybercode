FROM lua:5.3

# تحديث النظام وتثبيت الحزم الضرورية
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y redis-server curl git wget pkg-config libssl-dev libreadline-dev python3 python3-pip

# تثبيت luarocks (إذا لم يكن مثبتاً بالفعل)
RUN apt-get install -y luarocks

# تثبيت مكتبات Lua المطلوبة عبر luarocks
RUN luarocks install luasocket && \
    luarocks install luasec OPENSSL_LIBDIR=/usr/lib/x86_64-linux-gnu OPENSSL_INCDIR=/usr/include/openssl && \
    luarocks install redis-lua && \
    luarocks install dkjson

# تثبيت مكتبات Python المطلوبة
RUN pip3 install --no-cache-dir flask gunicorn

# تعيين مجلد العمل
WORKDIR /app

# نسخ الملفات من المستودع إلى الحاوية
COPY . /app

# الأمر الافتراضي لتشغيل Redis ثم تشغيل البوت
CMD ["bash", "-c", "redis-server --daemonize yes && lua start.lua"]