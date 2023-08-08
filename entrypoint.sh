#!/bin/bash
./kcn-linux-amd64/bin/kcnd start
while :
do
    ./kcn-linux-amd64/bin/kcnd status && sleep 1
done