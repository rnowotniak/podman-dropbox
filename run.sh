#!/bin/bash

set -e
set -x

cd
pwd

ps auxfw
mkdir -p ~/bin
cp -f /var/tmp/dropbox.py ~/bin/
tar xzvf /var/tmp/dropbox.$ARCH.tgz || exit 1

trap 'echo "SIGTERM received. Will run dropbox stop, and will wait for proc $PID to be gone"; set -x; ps auxfw; dropbox.py stop; wait $PID; exit $?' SIGTERM

~/.dropbox-dist/dropboxd &
PID=$!
wait $PID
exit $?

