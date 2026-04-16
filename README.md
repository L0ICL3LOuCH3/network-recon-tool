# Network Recon Tool

Script Bash de reconnaissance réseau pour identifier la disponibilité, l'adresse IP et les ports ouverts de plusieurs cibles.

## Fonctionnalités
- Scan de disponibilité (ping)
- Résolution DNS (nslookup)
- Scan de ports (80, 443, 22, 21, 25)
- Rapport horodaté sauvegardé automatiquement
- Affichage couleur (vert/rouge)

## Utilisation

1. Ajoute tes cibles dans `cible.txt` (une par ligne)
2. Lance le script :
```bash
./reconx.sh

Prérequis
nslookup : pkg install dnsutils
netcat : pkg install netcat-openbsd
Exemple de résultat

Cible:     google.com
Statut:    en ligne
IP:        172.217.23.174
Port 80:   OUVERT
Port 443:  OUVERT


Auteur
Loic — Étudiant cybersécurité @ Politecnico di Milano
