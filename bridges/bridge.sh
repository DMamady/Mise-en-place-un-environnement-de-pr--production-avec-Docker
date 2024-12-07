#!/bin/bash

# Création du premier réseau Docker en bridge
# bridge1 utilise le sous-réseau 192.168.0.0/24 et le pilote "bridge".
docker network create bridge1 --subnet=192.168.0.0/24 --driver=bridge

# Création du deuxième réseau Docker en bridge
# bridge2 utilise le sous-réseau 10.0.0.0/24 et le pilote "bridge".
docker network create bridge2 --subnet=10.0.0.0/24 --driver=bridge
