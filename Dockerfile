# استخدام Ubuntu كصورة أساسية
FROM ubuntu:latest

# تحديث الحزم وتثبيت المتطلبات الأساسية
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y lua5.3 luarocks redis-server curl python3 python3-pip git && \
    luarocks install luasocket && \
    luarocks install luasec && \
    luarocks install redis-lua && \
    luarocks install dkjson && \
    pip3 install --upgrade pip setuptools wheel && pip3 install flask gunicorn

# تعيين مجلد العمل
WORKDIR /app

# نسخ جميع الملفات المطلوبة إلى الحاوية
COPY . /app

# إعطاء الصلاحيات اللازمة
RUN chmod +x /app/start.lua

# تشغيل Redis ثم تشغيل البوت
CMD ["bash", "-c", "redis-server --daemonize yes && lua /app/start.lua"]
