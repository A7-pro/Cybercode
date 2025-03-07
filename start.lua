-- تحميل المكتبات المطلوبة
local redis = dofile("/app/File_Libs/redis.lua").connect("127.0.0.1", 6379)
local serpent = dofile("/app/File_Libs/serpent.lua")
local JSON = dofile("/app/File_Libs/dkjson.lua")
local json = dofile("/app/File_Libs/JSON.lua")
local URL = dofile("/app/File_Libs/url.lua")
local https = require("ssl.https")
local http = require("socket.http")
local socket = require("socket")

-- تشغيل Redis
os.execute("redis-server --daemonize yes")

-- مهلة قصيرة للتأكد من أن Redis يعمل قبل تشغيل البوت
os.execute("sleep 2")

-- تشغيل البوت في الخلفية
os.execute("lua /app/Cybercode.lua &")

-- إنشاء سيرفر ويب وهمي ليستمع لـ Render
local server = socket.bind("0.0.0.0", 8080)
print("🚀 Server is running on port 8080...")

while true do
    local client = server:accept()
    client:send("HTTP/1.1 200 OK\r\nContent-Length: 2\r\n\r\nOK")
    client:close()
end