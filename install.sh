#!/bin/bash

current_path=$(readlink -f $0)
current_dir=${current_path%/*}
target_dir="$(kf5-config --path services | cut -f1 -d':')"mkexeshortcut

if [[ $# > 0 ]]; then
    action="$1"
else
    if [ "$target_dir" != "$current_dir" ]; then
        action="--install"
    else
        action="--uninstall"
    fi
fi


if [ "$action" == "--install" ]; then
    echo -e "\e[1m\e[32mInstalling mkexeshortcut.\e[0m"
    mkdir -p $target_dir
    echo -en "\e[1m\e[1;33m"; cp -v mkexeshortcut.sh mkexeshortcut.desktop LICENSE $target_dir
    cp -Tv install.sh $target_dir/uninstall.sh
    echo -e "\e[1m\e[32mFinished installation.\e[0m"
    exit 0
elif [ "$action" == "--uninstall" ]; then
    echo -e "\e[1m\e[32mUninstalling mkexeshortcut.\e[0m"
    rm -Rvf $target_dir
    echo -e "\e[1m\e[32mFinished uninstalling.\e[0m"
    exit 0
else
    echo -e "\e[1m\e[31mInvalid argument. Valid arguments: --install or --uninstall. \e[0m"
fi
