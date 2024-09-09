#!/bin/bash

# Mise à jour des paquets et installation des dépendances
echo "Mise à jour des paquets et installation des dépendances..."
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Installation de Git
echo "Installation de Git..."
sudo apt-get install -y git

# Ajout de la clé GPG officielle de Docker
echo "Ajout de la clé GPG officielle de Docker..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Ajout du référentiel Docker
echo "Ajout du référentiel Docker..."
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# Mise à jour des paquets et installation de Docker
echo "Installation de Docker..."
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Ajout de l'utilisateur actuel au groupe Docker
echo "Ajout de l'utilisateur actuel au groupe Docker..."
sudo usermod -aG docker ${USER}

# Installation de Docker Compose
echo "Installation de Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Vérification des versions installées
echo "Vérification des versions installées..."
docker --version
docker-compose --version
git --version

# Clonage du dépôt GitHub
echo "Clonage du dépôt GitHub..."
git clone https://github.com/MariyaSha/StableDiffusion_GUI_App.git

# Accès au répertoire racine du projet
cd StableDiffusion_GUI_App/starter_files

sudo apt-get update && \
sudo apt-get install git-lfs && \
git-lfs install && \
git clone "https://huggingface.co/CompVis/stable-diffusion-v1-4"

wget https://github.com/Saafke/EDSR_Tensorflow/raw/master/models/EDSR_x2.pb

wget https://github.com/Saafke/EDSR_Tensorflow/raw/master/LICENSE -O edsr_license

wget https://huggingface.co/spaces/CompVis/stable-diffusion-license/blob/main/license.txt  -O sdhf_license

wget https://github.com/ChenyangSi/FreeU/raw/main/LICENSE -O freeu_license