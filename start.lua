local socket = require("socket")

os.execute("lua /app/Cybercode.lua &")
print("Started Cybercode.lua in background...")

local server, err = socket.bind("0.0.0.0", 8080)
if not server then
  print("Failed to bind server: " .. (err or "unknown error"))
  os.exit(1)
end
print("HTTP server is listening on port 8080...")

while true do
  local client = server:accept()
  client:send("HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-Length: 2\r\n\r\nOK")
  client:close()
end
