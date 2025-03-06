-- تحميل المكتبات المطلوبة
local redis = dofile("/app/File_Libs/redis.lua").connect("127.0.0.1", 6379)
local serpent = dofile("/app/File_Libs/serpent.lua")
local JSON = dofile("/app/File_Libs/dkjson.lua")
local json = dofile("/app/File_Libs/JSON.lua")
local URL = dofile("/app/File_Libs/url.lua")
local https = require("ssl.https")
local http = require("socket.http")

-- الحصول على معلومات الخادم
local Server_Done = io.popen("echo $SSH_CLIENT | awk '{ print $1}'"):read('*a'):gsub('[\n\r]+', '')
local User = io.popen("whoami"):read('*a'):gsub('[\n\r]+', '')
local IP = io.popen("curl -s ifconfig.me"):read('*a'):gsub('[\n\r]+', '') 
local Port = io.popen("echo ${SSH_CLIENT} | awk '{ print $3 }'"):read('*a'):gsub('[\n\r]+', '')

-- دالة لإنشاء ملف sudo.lua
local function Create_Info(Token, Sudo)
    local Write_Info_Sudo = io.open("/app/sudo.lua", 'w')
    Write_Info_Sudo:write(string.format([[ 
token = "%s"
Sudo = %s
]], Token, Sudo))
    Write_Info_Sudo:close()
end

-- دالة لكتابة البيانات تلقائيًا
local function AutoFiles_Write()
    if not redis:get(Server_Done.."Token_Write") then
        print("\27[1;34m»» Send Your Token Bot :\27[m")
        local token = io.read()
        if token ~= '' then
            local url, res = https.request('https://api.telegram.org/bot'..token..'/getMe')
            if res == 200 then
                redis:set(Server_Done.."Token_Write", token)
            else
                print("\27[1;31mInvalid Token!\27[0;39;49m")
                os.exit()
            end
        end
        os.execute('lua /app/start.lua')
        os.exit()
    end

    if not redis:get(Server_Done.."UserSudo_Write") then
        print("\27[1;34mSend Your Id Sudo :\27[m")
        local Id = io.read():gsub(' ','') 
        if tostring(Id):match('%d+') then
            redis:set(Server_Done.."UserSudo_Write", Id)
        end
        os.execute('lua /app/start.lua')
        os.exit()
    end

    Create_Info(redis:get(Server_Done.."Token_Write"), redis:get(Server_Done.."UserSudo_Write"))
end

local function Load_File()
    local f = io.open("/app/sudo.lua", "r")
    if not f then
        AutoFiles_Write()
    else
        f:close()
    end
end

Load_File()
