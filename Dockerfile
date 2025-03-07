FROM lua:5.3

# تثبيت التبعيات الأساسية
RUN apt-get update && apt-get install -y \
    libssl-dev \
    build-essential \
    luarocks

# تعيين متغيرات البيئة لـ OpenSSL
ENV OPENSSL_LIBDIR=/usr/lib/x86_64-linux-gnu
ENV OPENSSL_INCDIR=/usr/include/openssl

# تثبيت مكتبات Lua عبر luarocks مع تحديد إصدار Lua
RUN luarocks install luasocket --lua-version=5.3 && \
    luarocks install luasec 0.8-1 OPENSSL_LIBDIR=$OPENSSL_LIBDIR OPENSSL_INCDIR=$OPENSSL_INCDIR --lua-version=5.3 && \
    luarocks install redis-lua --lua-version=5.3 && \
    luarocks install dkjson --lua-version=5.3