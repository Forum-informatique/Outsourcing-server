#!/bin/bash
set -euo pipefail
rougefonce='\e[0;31m'
vertfonce='\e[0;32m'
neutre='\e[0;m'

echo "" > rapport.txt
echo "-------------------------------------------------------------" >> rapport.txt
echo "           Rapport sur votre serveur                    " >> rapport.txt
echo "-------------------------------------------------------------" >> rapport.txt
clear
echo "-------------------------------------------------------------"
echo -e "               ${rougefonce}Rapport sur votre serveur${neutre}                    "
echo -e  "-------------------------------------------------------------\n"

# afficher hostname
hostnamee=`cat /etc/hostname`
echo -e "${vertfonce}- Nom de la machine:${neutre} $hostnamee"
echo "" >> infogerance.txt
echo -e "- Nom de la machine :\n" >> rapport.txt
echo -e "$hostnamee:\n" >> rapport.txt
sleep 2
# afficher version kernel
versionkernel=`uname -r`
echo -e "${vertfonce}- La version du Kernel:${neutre} $versionkernel"
echo -e "- La version du Kernel:\n" >> rapport.txt
echo -e "$versionkernel\n" >> rapport.txt
sleep 2
# afficher version os
versionos=`lsb_release -d |awk '{print $2,$3,$4,$5}'`
echo -e "${vertfonce}- La version OS:${neutre} $versionos"
echo -e "- La version OS:\n" >> rapport.txt
echo -e "$versionos\n" >> rapport.txt
sleep 2
# le nombre de processeur
nbproc=`cat /proc/cpuinfo | grep processor | wc -l`
echo -e "${vertfonce}- Le nombre de processeur:${neutre} $nbproc\n"
echo -e "- Le nombre de processeur:\n $nbproc\n" >> rapport.txt
sleep 2
# afficher date
datesys=`date`
echo -e "${vertfonce}- La date:${neutre} $datesys"
echo -e "- La date:\n" >> rapport.txt
echo -e "$datesys\n" >> rapport.txt
sleep 2
# up depuis quand
upsys=`uptime | awk '{print $3,$4}' | sed "s/\,//"`
echo -e "${vertfonce}- Le serveur est UP depuis:${neutre} $upsys\n"
echo -e "- Le serveur est UP depuis: $upsys\n" >> rapport.txt
sleep 2
# afficher les connexions tcp udp actives
trafic=`netstat -pan | grep 'tcp\|udp'`
sleep 2
echo -e "${vertfonce}- Les connexions TCP|UDP actives:${neutre}\n $trafic\n"
echo -e "- Les connexions TCP|UDP actives:\n" >> rapport.txt
echo -e "$trafic\n" >> rapport.txt
echo "-------------------------------------------------------------" >> rapport.txt
sleep 5
# afficher les ip connectees en ssh
con=`who`
echo -e "${vertfonce}- Les ip connectees en ssh:${neutre}\n"
echo -e " $con\n"
echo -e "- Les ip connectees en ssh:\n" >> rapport.txt
echo -e "$con\n" >> rapport.txt
sleep 4
# afficher ram swap + charge high et charge low
consmem=`free -l -h | head -n 6 | awk '{print $1,$2,$3}'`
echo -e "${vertfonce}- Consommation RAM et swap:${neutre}\n $consmem\n"
echo -e "- Consommation RAM et swap:\n" >> rapport.txt
echo -e "$consmem\n" >> rapport.txt
sleep 2
# espace disque
esp=`df -h`
espin=`df -i`
echo -e "${vertfonce}- Espace disque et inode:${neutre} \n"
sleep 2
echo -e "$esp \n $espin \n"
echo -e "- Espace disque et inode: \n" >> rapport.txt
echo -e "$esp \n" >> rapport.txt
echo "-------------------------------------------------------------" >> rapport.txt
echo -e "$espin \n" >> rapport.txt
sleep 2
# lister les process qui consomme le plus de Ram
conspro=`ps -eo user,size,command | sort -k2 -rn | head -10`
echo -e "${vertfonce}- Top process qui consomment plus de Ram:\n${neutre}"
sleep 2
echo -e "$conspro\n"
echo -e "- Top process qui consomment plus de Ram:\n" >> rapport.txt
echo -e "$conspro\n" >> rapport.txt
echo "-------------------------------------------------------------" >> rapport.txt
sleep 8

# iptables
echo -e "${vertfonce}- Votre Pare feu:\n${neutre}"
sleep 2
parefeusys=`iptables -L -n`
echo -e "$parefeusys\n"
echo -e "- Votre Pare feu:\n $parefeusys\n" >> rapport.txt
echo "-------------------------------------------------------------" >> rapport.txt
sleep 8
# liste des  services installés sur le serveur
echo -e "${vertfonce}- La liste des services installes:${neutre}\n"
sleep 2
listeservice=`service --status-all`
echo -e "${vertfonce}- La liste des services installes:${neutre}\n" >> rapport.txt
echo -e "$listeservice\n" >> rapport.txt
sleep 8
clear
read -p 'Voulez vous recevoir le rapport par mail (oui/non):'  rep


if [ "$rep" = "oui" ] && [ ! -z "$rep" ]
then
        read -p 'Entrez votre adreese mail: '  admail
boite=$admail

cat rapport.txt | mail -s Rapport $boite
sleep 5
  echo -e "Mail envoye a $admail"
else

 echo -e "Script Termine"
sleep 5

fi
