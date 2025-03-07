from flask import Flask
import threading
import os

app = Flask(__name__)

@app.route('/')
def home():
    return "Bot is running!", 200

def run_bot():
    os.system("lua /app/start.lua")

if __name__ == "__main__":
    # تشغيل البوت في Thread منفصل حتى لا يتوقف السيرفر
    threading.Thread(target=run_bot).start()
    
    # تشغيل سيرفر Flask ليستمع على المنفذ 8080
    app.run(host="0.0.0.0", port=8080)
