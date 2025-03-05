FROM ubuntu:latest
RUN apt update && apt install -y lua5.3 luarocks redis-server
WORKDIR /app
COPY . .
CMD bash start.sh
