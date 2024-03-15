#!/bin/bash
#
if ! $(command -v unoconv &> /dev/null)
then
    echo "Installing unoconv.."
    apt install unoconv &> /dev/null
    echo
fi

mkdir Chromium_History
cd $HOME/Chromium_History

tables=($(sqlite3 $HOME/.config/chromium/Default/History ".tables" ".exit"))

for table_name in ${tables[*]}
do
    sqlite3 $HOME/.config/chromium/Default/History << EOF
.mode csv
.output $table_name.csv
SELECT * FROM $table_name;
.exit
EOF
done

read -n1 -p "Are you want the xlsx file format? (extra)" answer
echo
if [ "$answer"="y" ] || [ "$answer"="Y" ]
then
    for conv_name in $HOME/Chromium_History/*
    do
        unoconv -f xlsx $conv_name &> /dev/null
    done 
fi

