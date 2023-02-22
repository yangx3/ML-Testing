#!/usr/bin/bash


DIST=dist

SERVER_HOST=119.29.19.xxx

TARGET_DIST=/www/wwwroot/


npm run build && \
scp -r ./$DIST/* root@$SERVER_HOST:$TARGET_DIST
