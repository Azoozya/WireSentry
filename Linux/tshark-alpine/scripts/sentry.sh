#!/usr/bin/env bash
vars=("$@")
src=${vars[0]}
dst=${vars[1]}
year=`date +%Y`
dur=1

for xor in {1..5..1}
do
  tshark -i any -a duration:$dur -F pcap -w $xor.tshark_cap
  foldername=`date +%Y_%T`
  ./script.sh $src $dst $foldername $xor.tshark_cap 
 #echo "[$xor] $src -> $dst"
done

while [ `cat $foldername/trame.json | wc -c | cut -c 1-${#-}` -gt 6 ];do
  #echo "Dromadaire : `tshark -r 5.tshark_cap | wc -w | cut -c 1`"
  rm *.tshark_cap
  rm -r $year*
  for xor in {1..5..1}
  do
    foldername=`date +%Y_%T`
    tshark -i any -a duration:$dur -F pcap -w $xor.tshark_cap
    ./script.sh $src $dst $foldername $xor.tshark_cap
    #echo "[$xor] $src -> $dst"
  done
done

cp -r $year* /archive
bash
## compression ?
## envoi ?
