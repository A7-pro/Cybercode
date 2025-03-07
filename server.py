from flask import Flask
import threading
import os
import time

app = Flask(__name__)

@app.route('/')
def home():
    return "Cybercode Bot is running!", 200

def run_bot():
    while True:
        os.system("lua /app/start.lua")
        time.sleep(5)  # إعادة تشغيل البوت في حال توقف

if __name__ == "__main__":
    # تشغيل البوت في Thread منفصل حتى لا يوقف سيرفر Flask
    threading.Thread(target=run_bot, daemon=True).start()
    
    # تشغيل سيرفر Flask ليستمع على المنفذ المطلوب
    port = int(os.environ.get("PORT", 8080))
    app.run(host="0.0.0.0", port=port)
