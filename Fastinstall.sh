#!/usr/bin/env bash

cd $HOME/Cybercode
rm -rf $HOME/.telegram-cli

install() {
    apt update && apt upgrade -y
    apt install -y dnsutils tmux luarocks screen libreadline-dev libconfig-dev libssl-dev \
                   lua5.2 liblua5.2-dev lua-socket lua-sec lua-expat libevent-dev make \
                   unzip git redis-server autoconf g++ libjansson-dev libpython-dev \
                   expat libexpat1-dev upstart-sysv

    sudo chmod +x tg Cybercode ts
    ./ts
}

if [ "$1" = "ins" ]; then
    install
fi

chmod +x install.sh
lua start.lua
