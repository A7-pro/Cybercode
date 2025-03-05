#!/usr/bin/env bash

cd $HOME/Cybercode

install() {
    rm -rf $HOME/.telegram-cli
    sudo chmod +x tg Cybercode ts
    ./ts
}

get() {
    rm -fr Cybercode.lua sudo.lua
    wget -q "https://raw.githubusercontent.com/SourceCybercode/Cybercode/master/Cybercode.lua"
    lua start.lua
}

install_all() {
    apt update && apt upgrade -y
    apt install -y dnsutils tmux luarocks screen libreadline-dev libconfig-dev libssl-dev \
                   lua5.2 liblua5.2-dev lua-socket lua-sec lua-expat libevent-dev make \
                   unzip git redis-server autoconf g++ libjansson-dev libpython-dev \
                   expat libexpat1-dev upstart-sysv

    wget -q http://luarocks.org/releases/luarocks-2.2.2.tar.gz
    tar zxpf luarocks-2.2.2.tar.gz
    cd luarocks-2.2.2
    ./configure
    sudo make bootstrap
    sudo luarocks install luasocket
    sudo luarocks install luasec
    cd ..
    rm -rf luarocks*
}

if [ "$1" = "ins" ]; then
    install
elif [ "$1" = "get" ]; then
    get
else
    install_all
    lua start.lua
fi
