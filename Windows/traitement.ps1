$client = $args[ 0 ]
$server = $args[ 1 ]
$src_file = $args[ 2 ]
$dirName = $args[ 3 ]
$GateWay = $args[ 4 ]
$entry_port = $args[ 5 ]
$output_port = $args[ 6 ]
$tshark = "D:\Wireshark\tshark.exe"

##On crée les dossiers "Client" et "Serveur" et à minima 1 fichier (vide)
New-Item -Path .\$dirName\Client -ItemType directory
New-Item -Path .\$dirName\Client\pacquets.txt -ItemType File
New-Item -Path .\$dirName\Server -ItemType directory
New-Item -Path .\$dirName\Server\pacquets.txt -ItemType File

##On split
.$tshark -r $src_file -Y "(ip.src==$client)&&(ip.dst==$server)" >> $dirName\Client\pacquets.txt
#.$tshark -r $src_file -Y "(ip.src==$client)&&(ip.dst==$server)&&(tcp.port=$ouput_port)" >> $dirName\Client\pacquets.txt

.$tshark -r $src_file -Y "(ip.src==$server)&&(ip.dst==$client)" >> $dirName\Server\pacquets.txt
#.$tshark -r $src_file -Y "(ip.src==$server)&&(ip.dst==$client)&&(tcp.port=$entry_port)" >> $dirName\Server\pacquets.txt

.$tshark -r $src_file -T json >> $dirName\trame.json
