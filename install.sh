#!/bin/bash

echo -e "\e[1m\e[32mInstalling mkexeshortcut.\e[0m"

mkdir -p $HOME/.local/share/kservices5/mkexeshortcut

echo -en "\e[1m\e[1;33m"; cp -v mkexeshortcut.sh mkexeshortcut.desktop LICENSE $HOME/.local/share/kservices5/mkexeshortcut

echo -e "\e[1m\e[32mFinished installation.\e[0m"

exit 0
