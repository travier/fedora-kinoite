#!/bin/bash

source /usr/src/kde/usr/lib64/libexec/plasma-dev-prefix.sh

# This is a bit of a hack done because systemd starts in pam, and we only set our dev paths after all that is complete
# This copies everything into a transient runtime directory that systemd reads and reloads the units

if [ ! -z  "$XDG_RUNTIME_DIR" ]; then
    mkdir -p "$XDG_RUNTIME_DIR/systemd/user.control"
    command cp -r /usr/src/kde/usr/lib/systemd/user/* $XDG_RUNTIME_DIR/systemd/user.control
    systemctl --user daemon-reload
fi


startplasma$@

if [ ! -z  "$XDG_RUNTIME_DIR" ]; then
    cd /usr/src/kde/usr/lib/systemd/user
    for i in *; do
        rm -r $XDG_RUNTIME_DIR/systemd/user.control/$i
    done
    systemctl --user daemon-reload
fi
