local redis = dofile("./File_Libs/redis.lua").connect("127.0.0.1", 6379)
local serpent = dofile("./File_Libs/serpent.lua")
local JSON = dofile("./File_Libs/dkjson.lua")
local json = dofile("./File_Libs/JSON.lua")
local URL = dofile("./File_Libs/url.lua")
local https = require("ssl.https")
local http = require("socket.http")

local Server_Done = io.popen("echo $SSH_CLIENT | awk '{ print $1}'"):read('*a'):gsub('[\n\r]+', '')
local User = io.popen("whoami"):read('*a'):gsub('[\n\r]+', '')
local IP = io.popen("dig +short myip.opendns.com @resolver1.opendns.com"):read('*a'):gsub('[\n\r]+', '')
local Port = io.popen("echo ${SSH_CLIENT} | awk '{ print $3 }'"):read('*a'):gsub('[\n\r]+', '')

local function Create_Info(Token, Sudo)  
    local Write_Info_Sudo = io.open("sudo.lua", 'w')
    Write_Info_Sudo:write(string.format([[
s = "mwote"
q = "kmhhh"
token = "%s"
Sudo = %s
]], Token, Sudo))
    Write_Info_Sudo:close()
end  

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
            end
        end
        os.execute('lua start.lua')
    end

    if not redis:get(Server_Done.."UserSudo_Write") then
        print("\27[1;34mSend Your Id Sudo :\27[m")
        local Id = io.read():gsub(' ','') 
        if tostring(Id):match('%d+') then
            redis:set(Server_Done.."UserSudo_Write", Id)
        end
        os.execute('lua start.lua')
    end

    Create_Info(redis:get(Server_Done.."Token_Write"), redis:get(Server_Done.."UserSudo_Write"))   
end

local function Load_File()  
    local f = io.open("./sudo.lua", "r")  
    if not f then   
        AutoFiles_Write()  
    else   
