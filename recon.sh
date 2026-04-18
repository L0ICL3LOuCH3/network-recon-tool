#!/bin/bash

#==========================================
#Network Recon Tool
#Auteur: Loic
#Description : Scanner de Reconnaissance reseau
#==========================================

#----Couleurs------
VERT='\033[0;32m'
ROUGE='\033[0;31m'
JAUNE='\033[0;33m'
RESET='\033[0m'

#____Fichiers______

RAPPORT="rapport_$(date +%Y-%m-%d_%H-%M-%S).txt"
CIBLES="cible.txt"

#============================================
#FONCTION
#===========================================

afficher_titre() {
	echo "====================================="|tee -a "$RAPPORT"
	echo "        NETWORK RECOOL TOOL          "|tee -a "$RAPPORT"
	echo "====================================="|tee -a "$RAPPORT"
	printf "%-10s %s\n" "Date:" "$(date)" |tee -a "$RAPPORT"
	echo "*************************************"|tee -a "$RAPPORT"
	echo " "

}

scanner_ping() {

	if ping -c 1 "$1" > /dev/null 2>&1; then
	printf "%-10s %b\n" "statut:" "${VERT}online ${RESET}" |tee -a "$RAPPORT"
	return 0
	else
	printf "%-10s %b\n" "statut:" "${ROUGE}hors ligne${RESET}" |tee -a "$RAPPORT"
	erreur=$((erreur +1))
	return 1
	fi
}

scanner_ip() {
	if [ -z "$IP" ]; then
	printf "%-10s %b\n" "ip:" "${ROUGE}INTROUVABLE${RESET}" |tee -a "$RAPPORT"
	else
	printf "%-10s %b\n" "ip:" "$IP" | tee -a "$RAPPORT"
	ip_trouve=$((ip_trouve +1))
	fi
}

reconnaissance_ip() {
	if [[ "$1" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
	IP="$1"
	else
	IP=$(nslookup "$1" | grep "Address" | grep -v "#" | tail -2 | head -1 | awk '{print $2}')
	fi
}

scanner_port() {
	for port in 80 443 21 22 24 25; do
	if nc -zw1 "$1" "$port" > /dev/null 2>&1; then
	printf "%-10s %b\n" "port $port:" "${VERT}OUVERT${RESET}" |tee -a "$RAPPORT"
	port_ouvert=$((port_ouvert + 1))
	else 
	printf "%-10s %b\n" "port $port:" "${ROUGE}FERMÉ${RESET}" |tee -a "$RAPPORT"
	#port_ouvert=$((port_ouvert + 1))
	fi
	done
}

#=======≈====================================
#VERIFICATION
#============================================
	if ! command -v nslookup > /dev/null 2>&1; then
	echo "nslookup n'est pas installer" | tee -a "$RAPPORT"
	exit 1
	fi
	if ! command -v  nc > /dev/null 2>&1; then
	echo "nc n'est pas installer" | tee -a "$RAPPOR"T
	fi

#=============================================
#COMPTEUR
#=============================================
total_cible=0
ip_trouve=0
port_ouvert=0
erreur=0


#=============================================
#MAIN
#=============================================
afficher_titre

while read cible; do

total_cible=$((total_cible + 1))

echo "----------------------------------------"
printf "%-10s %b\n" "cible:" "${JAUNE}$cible${RESET}" |tee -a "$RAPPORT"
echo "----------------------------------------"

if scanner_ping "$cible"; then
	scanner_ip "$cible";
	reconnaissance_ip "$cible"
	scanner_port "$IP";
fi

echo " " |tee -a "$RAPPORT"

done < "$CIBLES"


echo "==============RESUMÉ FINALE=================" |tee -a "$RAPPORT"
echo "=================" |tee -a "$RAPPORT"
printf "%-15s %s\n" "cibles totales:" "$total_cible" |tee -a "$RAPPORT"
printf "%-15s %s\n" "ip trouvé:" "$ip_trouve" |tee -a "$RAPPORT"
printf "%-15s %s\n" "port ouvert:" "$port_ouvert" |tee -a "$RAPPORT"
printf "%-15s %s\n" "erreur:" "$erreur" |tee -a "$RAPPORT"
echo "============================================" |tee -a "$RAPPORT"


echo "=============================================" |tee -a "$RAPPORT"
echo "Rapport sauvegarde : $RAPPORT"
echo "---------------------------------------------" |tee -a "$RAPPORT"
