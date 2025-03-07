local socket = require("socket")

-- تشغيل البوت في خلفية منفصلة
local function run_bot()
  os.execute("lua /app/Cybercode.lua")
end

local co = coroutine.create(run_bot)
coroutine.resume(co)

-- إنشاء سيرفر ويب بسيط باستخدام LuaSocket على المنفذ 8080
local server = assert(socket.bind("0.0.0.0", 8080))
print("HTTP server is listening on port 8080...")

while true do
  local client = server:accept()
  client:send("HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-Length: 2\r\n\r\nOK")
  client:close()
end