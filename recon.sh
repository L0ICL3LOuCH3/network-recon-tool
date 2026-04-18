#!/bin/bash
# --- DEFINIZIONE COLORI ---
VERT='\033[0;32m'
ROUGE='\033[0;31m'
NC='\033[0m' # No Color (Reset)
RESET='\033[0m'

echo "======== NETWORK RECON TOOL =======" |tee -a  rapport.txt
printf "%-10s %s\n" "Date" "$(date)" | tee -a rapport.txt

while read cible; do
 
printf "%-10s %s\n" "Cible:" "$cible" | tee -a rapport.txt

if ! command -v nslookup > /dev/null 2>&1; then #
	echo "nslookup manquant - installe dnsutils"
		exit 1
fi

if  ping -c 1 "$cible" > /dev/null; then
        printf "%-10s %b\n" "statut:" "${VERT}en ligne${RESET}" | tee -a rapport.txt
 IP=$(nslookup $cible | grep "Address"| grep -v "#" |tail -2| head -1|awk '{print $2}')
	if [ -z "$IP" ]; then
		printf "%-10s %b\n" "ip:" "${ROUGE}introuvable${RESET}" | tee -a rapport.txt

	else
#printf "%-10s %s\n" "statut:" "${VERT}en ligne${RESET}" | tee -a rapport.txt
        printf "%-10s %s\n" "ip:" "$IP" | tee -a rapport.txt
	fi 
#printf "%-10s %s\n" "ip:" " $IP" | tee -a rapport.txt
else
        printf "%-10s %b\n"  "statut:" "${ROUGE} hors ligne${RESET}"| tee -a rapport.txt
fi
for port in 80 443 22 21 25; do
    if nc -zw1 "$cible" "$port" > /dev/null 2>&1; then
        printf "%-10s %b\n" "port $port:" "${VERT}ouvert${RESET}" | tee -a rapport.txt
    else
        printf "%-10s %b\n" "port $port:" "${ROUGE}fermé${RESET}" | tee -a rapport.txt
    fi
done
echo "-----------------------------------" | tee -a rapport.txt

done < cible.txt
