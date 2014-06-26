#!/bin/bash

FILE_PATH=$1

while true
do
    grep "<PASSWORD>" "$FILE_PATH" >/dev/null || break
    sed -i.bak -e "0,/<PASSWORD>/s/<PASSWORD>/$(pwgen 30 1)/" "$FILE_PATH"
done
