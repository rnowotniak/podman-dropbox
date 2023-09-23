#!/bin/bash

set -e

ps auxfw
mkdir -p ~/bin
cp -f /var/tmp/dropbox.py ~/bin/
tar xzvf /var/tmp/dropbox.$ARCH.tgz || exit 1
nohup ~/.dropbox-dist/dropboxd 2>&1 &
ps auxfw
tail -f nohup.out &

while true; do
	sleep 20
	pidof dropbox &>/dev/null || { ps auxfw; echo "No dropbox process is running, terminating the container."; exit 1; }
done
	

