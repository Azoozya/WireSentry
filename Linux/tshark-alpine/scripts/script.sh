#!/bin/bash
#args[0] ip_src ; args[1] ip_dst ; args[2] foldername ; args[3] filename
args=("$@")
mkdir ${args[2]}
cd ${args[2]}
mkdir ${args[0]} ${args[1]}
cd ..
path_src=${args[2]}/${args[0]}
path_dst=${args[2]}/${args[1]}
tshark -r ${args[3]} -Y "(ip.src==${args[0]})&&(ip.dst==${args[1]})" >> $path_src/client.txt
tshark -r ${args[3]} -Y "(ip.src==${args[1]})&&(ip.dst==${args[0]})" >> $path_dst/serveur.txt
tshark -r ${args[3]} -T json >> ${args[2]}/trame.json

#&&(tcp.port==80)
