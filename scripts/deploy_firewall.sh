#!/bin/bash

# Construction de l'image Pare-feu
docker build -t conteneurparefeuimage:v1.0.0 -f ../ContainerFirewallFile .

# Lancement du conteneur Pare-feu
docker run -d --cap-add=NET_ADMIN --name ContainerPareFeu --network bridge1 --ip 192.168.0.2 conteneurparefeuimage:v1.0.0 sleep infinity

# Connexion au deuxième réseau
docker network connect bridge2 --ip 10.0.0.2 ContainerPareFeu
