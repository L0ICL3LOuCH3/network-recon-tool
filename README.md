# Network Recon Tool

Script Bash de reconnaissance réseau pour identifier la disponibilité, l’adresse IP et les ports ouverts de plusieurs cibles.

## Fonctionnalités

- Scan de disponibilité avec `ping`
- Résolution DNS avec `nslookup`
- Scan de ports avec `nc`
- Génération automatique d’un rapport horodaté
- Affichage couleur dans le terminal
- Analyse de plusieurs cibles à partir d’un fichier

## Ports testés

- 80
- 443
- 21
- 22
- 24
- 25

## Fichiers du projet

- `reconx.sh` : script principal
- `cible.txt` : liste des cibles à scanner
- `rapport_YYYY-MM-DD_HH-MM-SS.txt` : rapport généré automatiquement

## Utilisation

1. Ajoute tes cibles dans `cible.txt`, une par ligne

Exemple :

```text
google.com
youtube.com
unimi.it
8.8.8.8


#Prérequis
Installer les outils nécessaires :
Bash
pkg install dnsutils
pkg install netcat-openbsd


#Exemple de résultat

cible:     google.com
statut:    online
ip:        172.217.23.174
port 80:   OUVERT
port 443:  OUVERT
port 21:   FERMÉ
port 22:   FERMÉ


#Auteur

Loic@lelouche
