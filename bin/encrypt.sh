#!/usr/bin/env bash

if [ -z "$1" ]; then
    echo "Please specify GPG key as the first argument"
    exit
fi

KEY_ID=$1

function encrypt {
    gpg --encrypt --batch --yes -r $KEY_ID $1
    if [ ! "$?" -eq "0" ]; then
        exit
    fi
}

encrypt inventory/group_vars/ydns.yml

FILES=$(ls ssh/oracle* | grep -v \.gpg)
for f in $FILES; do
    encrypt $f
done
