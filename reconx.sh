#!/bin/bash

#==========================================
#Network Recool Tool
#Auteur: Loic
#Description : Scanner de Reconnaissance reseau
#==========================================

#----Couleurs------
VERT='\033[0;32m'
ROUGE='\033[0;31m'
JAUNE='\033[0;33m'
RESET='\033[0m'

#____Fichiers______

RAPPORT="rapport.txt"
CIBLES="cible.txt"

#============================================
#FONCTION
#===========================================

afficher_titre() {
	echo "====================================="|tee -a $RAPPORT
	echo "        NETWORK RECOOL TOOL          "|tee -a $RAPPORT
	echo "====================================="|tee -a $RAPPORT
	printf "%-10s %s\n" "Date:" "$(date)"
	echo " "

}

scanner_ping() {

	if ping -c 1 "$1" > /dev/null 2>&1; then
	printf "%-10s %b\n" "statut:" "${VERT}online ${RESET}" |tee -a $RAPPORT
	return 0
	else
	printf "%-10s %b\n" "statut:" "${ROUGE}hors ligne${RESET}" |tee -a $RAPPORT
	return 1
	fi
}

scanner_ip() {
	IP=$(nslookup "$1" | grep "Address" | grep -v "#" | tail -2 | head -1 | awk '{print $2}')
	if [ -z "$IP" ]; then
	printf "%-10s %b\n" "ip:" "${ROUGE}INTROUVABLE${RESET}" |tee -a $RAPPORT
	else
	printf "%-10s %b\n" "ip:" "$IP" | tee -a $RAPPORT
	fi
}

scanner_port() {
	for port in 80 443 21 22 24 25; do
	if nc -zw1 "$1" "$port" > /dev/null 2>&1; then
	printf "%-10s %b\n" "port $port:" "${VERT}OUVERT${RESET}" |tee -a $RAPPORT
	else 
	printf "%-10s %b\n" "port $port:" "${ROUGE}FERMÉ${RESET}" |tee -a $RAPPORT
	fi
	done
}

#=======≈====================================
#VERIFICATION
#============================================
	if ! command -v nslookup > /dev/null 2>&1; then
	echo "nslookup n'est pas installer" | tee -a $RAPPORT
	exit 1
	fi
	if ! command -v  nc > /dev/null 2>&1; then
	echo "nc n'est pas installer" | tee -a $RAPPORT
	fi
#=============================================
#MAIN
#=============================================
afficher_titre

while read cible; do
echo "----------------------------------------"
printf "%-10s %b\n" "cible:" "${JAUNE}$cible${RESET}" |tee -a $RAPPORT
echo "----------------------------------------"

if scanner_ping "$cible"; then
	scanner_ip "$cible";
	scanner_port "$cible";
fi

echo " " |tee -a $RAPPORT

done <  $CIBLES

echo "=============================================" |tee -a $RAPPORT
echo "Rapport sauvegarde : $RAPPORT"
echo "---------------------------------------------" |tee -a $RAPPORT
