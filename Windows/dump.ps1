$server = $args[ 0 ]
$client = $args[ 1 ]
$tshark = "D:\Wireshark\tshark.exe"
$duration = 5 #Durée (en secondes) d'un enregistrement
$MaxCapture = 5 #Nombre (en fichiers) d'enregistrements
#nb_interface : Contient le nombre d'interfaces réseaux disponibles
#interfaces : tableau de "-i $x" où x prend les valeurs succesives de 1 à nb_interface
#xor/iterative : variables iteratives pour le for
#IP/GW : contiennent les valeurs de la première IP connecté et de la passerelle associée
#colItems contient l'ensemble des infos des différents interfaces
#dirName : Le nom du "dossier" actuel (1 enregistrement 1 fichier)
#lastDirName : fais une sauvegarde du dernier dossier crée (et rempli)


##On génère le -i any version Windows [ATTENTION , -TotalCount 4 lit jusqu'à la 4ème ligne , potentiellement pas la bonne ligne en fonction des Systèmes]
  .$tshark -D | Measure-Object -line > txt.file
  $nb_interface = (Get-Content txt.file -TotalCount 4)[-1]
  $nb_interface = [int]$nb_interface
  rm txt.file

  $interfaces = @(1..$nb_interface)
  for ($xor = 1 ; $xor -lt (($nb_interface)+1) ; $xor++)
  {
    $interfaces[ ($xor-1) ] = "-i $xor"
  }

  ##On récupère l'IP gateway et 'local' , seulement les 1ers actifs
  $strComputer ="."
  $colItems = Get-WmiObject Win32_NetworkAdapterConfiguration | where{$_.DefaultIPGateway -ne $null}
  $IP = ($colItems.IPAddress[ 0 ])
  $GW = ($colItems.DefaultIPGateway[ 0 ])

Do{
  ##On fait le ménage et on save la date à un certain format (pour le ménage et le nom du dossier)
  $dirName = date
  $year = $dirName.ToString("yyyy")

  rm *.cap
  rm -r *$year*

  ##On fait la capture pendant $MaxCapture fichiers de captures
  for($iterative=1 ; $iterative -lt ($MaxCapture)+1 ; $iterative++)
    {
    $capture_file = "$iterative.cap"
    $dirName = $dirName.ToString("HH_mm_ss__yyyy_MM_dd")
    mkdir "$dirName"
    .$tshark -i Wi-Fi -f "host $IP" -a duration:$duration -F pcap -w $capture_file
    #.\traitement.ps1 $client $server $capture_file $dirName $GW
    .\traitement.ps1 $IP $GW $capture_file $dirName  #Utilisé pour test uniquement , à la place de la ligne d'avant
    $lastDirName = $dirName
    $dirName = date
    }

  #On récupère le nombre de symboles/lettres/chiffres il y'a dans le fichier (ne comptent que les caractères imprimables)
  $file = "$lastDirName\trame.json"
  Get-Content .\$file | Measure-Object -Character > txt.file
  $nb_words = (Get-Content txt.file -TotalCount 4)[-1]
  $nb_words = [int]$nb_words
  rm txt.file
} Until($nb_words -lt 6)



  ## -Namespace "root\CIMV2" est peut-être à ajouter à la ligne "$colItems = Get-WmiObject Win32_NetworkAdapterConfiguration..."
## Get-Content test.csv | Select-String "Tony Passaquale" ~= grep
