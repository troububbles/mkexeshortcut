#!/bin/bash

if [ ! $(command -v wrestool) ]; then
    echo -e "\e[1m\e[31mERROR: Missing dependency\e[0m \e[3m\e[96micoutils\e[0m\e[1m\e[31m.\e[0m"
    exit 3
fi

if [ $(id -u) == 0 ]; then
    echo -e "\e[1m\e[31mERROR: Refusing to run\e[0m \e[3m\e[96mmkExeShortcut\e[0m\e[1m\e[31m as root.\e[0m"
    exit 4
fi

if [[ $# < 1 || $# > 2 ]]; then
    echo -e "\e[1m\e[31mERROR: Incorrect number of arguments.\e[0m\n\e[1mUsage:\e[0m \e[3mmkexeshortcut <filename> [output]\e[0m\e[1m\e[31m.\e[0m"
    exit 5
fi

input="$1"

if ( file --mime-type "$input" | grep -o "application/x-dosexec" >/dev/null ); then
    echo -e "\e[1m\e[1;33mWorking on file:\e[0m \e[3m\e[96m\"$input\"\e[0m\e[1m\e[1;33m.\e[0m"
else
    echo -e "\e[1m\e[31mERROR: File is not a Windows executable:\e[0m \e[3m\e[96m\"$input\"\e[0m\e[1m\e[31m.\e[0m"
    exit 6
fi

input_folder=${input%/*}

if [ ! -w "$input_folder" ]; then
    echo -e "\e[1m\e[31mERROR: Input folder is not writable:\e[0m \e[3m\e[96m\"$input_folder\"\e[0m\e[1m\e[31m.\e[0m"
    exit 7
fi

input_filename=${input##*/}
input_title=$(echo ${input_filename%.exe} | sed -s "s/_/ /g")

# Search for user's desktop #
desktop="$(xdg-user-dir DESKTOP)"
output="$desktop/$input_title.desktop"

# If a second argument was given, interpret it as the output location. #
if [ $# == 2 ]; then
    if [ -d "$2" ]; then
        if [ -w "$2" ]; then
            output="$2/$input_title.desktop"
        else
            echo -e "\e[1m\e[31mERROR: Folder is not writable:\e[0m \e[3m\e[96m\"$2\"\e[0m\e[1m\e[31m.\e[0m"
            exit 8
        fi
    else
        echo -e "\e[1m\e[31mERROR: Parameter is not a folder:\e[0m \e[3m\e[96m\"$2\"\e[0m\e[1m\e[31m.\e[0m"
        exit 9
    fi
elif [ ! -w $desktop ]; then
    echo -e "\e[1m\e[31mERROR: Folder is not writable:\e[0m \e[3m\e[96m\"$desktop\"\e[0m\e[1m\e[31m.\e[0m"
    exit 8
fi

echo -e "\e[1m\e[32mYou're good to go.\e[0m"

echo -e "\e[1m\e[95mCMD PARAMS
| FILENAME\e[0m \e[3m\e[96m$input_filename\e[0m \e[1m\e[95m
| FOLDER\e[0m   \e[3m\e[96m$input_folder\e[0m \e[1m\e[95m
| TITLE\e[0m    \e[3m\e[96m$input_title\e[0m \e[1m\e[95m
| OUTPUT\e[0m   \e[3m\e[96m$output\e[0m"

echo -e "\e[1m\e[1;33mExtracting icon resources from executable.\e[0m"

wrestool --type=-14 --extract --output="$input_folder/$input_title.ico" "$input"
if [[ $? > 0 ]]; then
    echo -e "\e[1m\e[31mAn error has occurred while extracting resources.\e[0m ($?)"
else
    echo -e "\e[1m\e[32mFinished extracting resources.\e[0m"
fi

icon_path="$input_folder/$input_title.ico"

if ( file --mime-type "$icon_path" | grep -o "image/" >/dev/null ); then
    echo -e "\e[1m\e[32mSelected icon file:\e[0m \e[3m\e[96m\"$icon_path\"\e[0m\e[1m\e[32m.\e[0m"
else
    echo -e "\e[1m\e[1;33mWarning: File is not an image:\e[0m \e[3m\e[96m\"$icon_path\"\e[0m\e[1m\e[1;33m.\e[0m"
    echo -e "\e[1m\e[1;33mTrying to extract alternative icons.\e[0m"

    wrestool --type=-3 --extract --output="$input_folder/$input_title.ico" "$input"

    if ( file --mime-type "$icon_path" | grep -o "image/" >/dev/null ); then
        echo -e "\e[1m\e[32mSelected icon file:\e[0m \e[3m\e[96m\"$icon_path\"\e[0m\e[1m\e[32m.\e[0m"
    else
        echo -e "\e[1m\e[31mWarning: File is not an image:\e[0m \e[3m\e[96m\"$icon_path\"\e[0m\e[1m\e[31m.\e[0m"
    fi
fi

echo "[Desktop Entry]
Type=Application
MimeType=application/x-dosexec
Exec=\"$input\"
Name=$input_title
Path=$input_folder/
Icon=$icon_path
Comment=Launch $input_title
Comment[ar]=الإطلاق $input_title
Comment[cs]=Spustit $input_title
Comment[da]=Start $input_title
Comment[de]=$input_title starten
Comment[el]=Εκκίνηση $input_title
Comment[en]=Launch $input_title
Comment[es]=Iniciar $input_title
Comment[fi]=Käynnistä $input_title
Comment[fr]=Lancer $input_title
Comment[it]=Avviare $input_title
Comment[hi]=$input_title लॉन्च करें
Comment[hu]=Indítsa $input_title
Comment[hy]=Սկսել $input_title
Comment[id]=Luncurkan $input_title
Comment[is]=Ræstu $input_title
Comment[lt]=Palaist $input_title
Comment[nl]=$input_title starten
Comment[pl]=Uruchom $input_title
Comment[pt]=Iniciar $input_title
Comment[ru]=Запустить $input_title
Comment[sv]=Starta $input_title
Comment[th]=เปิด $input_title
Comment[uk]=Запустіть $input_title
Comment[vi]=Khởi chạy $input_title
Comment[zh]=启动$input_title
StartupNotify=true
Terminal=false" > "$output"

if [ ! -f "$output" ]; then
    echo -e "\e[1m\e[31mERROR: The file\e[0m \e[3m\e[96m\"$output\"\e[0m \e[1m\e[31mcould not be created.\e[0m"
    exit 10
fi

echo -e "\e[1m\e[1;33mSetting execute permissions.\e[0m"

chmod +x "$input"
chmod +x "$output"

if [[ $? > 0 ]]; then
    echo -e "\e[1m\e[31mERROR: couldn't set execute permission.\e[0m ($?)"
    exit 11
else
    echo -e "\e[1m\e[32mShortcut successfully generated on\e[0m \e[3m\e[96m\"$output\"\e[1m\e[32m.\e[0m"
fi

exit 0
