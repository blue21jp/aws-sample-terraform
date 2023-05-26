#!/bin/bash

if [ $(uname) == "Darwin" ]; then
  ip=$(ifconfig | grep "inet " | grep -v 127 | cut -d' ' -f2)
else
  ip=$(hostname -I | cut -d' ' -f1)
fi
cat<<EOF
{"ip":"$ip"}
EOF
