#!/bin/bash

# Fonction pour afficher l'espace disque restant
check_disk_space() {
    echo "Espace disque restant :"
    df -h /
    echo "-------------------------------------------------"
}

# Mise à jour des paquets et installation des dépendances
echo "Mise à jour des paquets et installation des dépendances..."
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common git
check_disk_space

# Installation de Git
echo "Installation de Git..."
sudo apt-get install -y git
check_disk_space

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
check_disk_space

# Ajout de l'utilisateur actuel au groupe Docker
echo "Ajout de l'utilisateur actuel au groupe Docker..."
sudo usermod -aG docker ${USER}

# Installation de Docker Compose
echo "Installation de Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
check_disk_space

# Vérification des versions installées
echo "Vérification des versions installées..."
docker --version
docker-compose --version
git --version

# Clonage du dépôt GitHub
echo "Clonage du dépôt GitHub..."
git clone https://github.com/sivani88/stable-diffusion.git
check_disk_space

# Accès au répertoire racine du projet
cd stable-diffusion/StableDiffusion_GUI_App/starter_files

# Installation de Git LFS et téléchargement du modèle Stable Diffusion
echo "Installation de Git LFS..."
sudo apt-get install -y git-lfs
git-lfs install

echo "Clonage du modèle Stable Diffusion v1-4..."
git clone "https://huggingface.co/CompVis/stable-diffusion-v1-4"
check_disk_space

# Vérification des fichiers volumineux téléchargés
echo "Vérification des fichiers volumineux..."
ls -lh stable-diffusion-v1-4/unet
ls -lh stable-diffusion-v1-4/vae
ls -lh stable-diffusion-v1-4/text_encoder

# Téléchargement du modèle EDSR et des licences
echo "Téléchargement du modèle EDSR et des licences..."
wget https://github.com/Saafke/EDSR_Tensorflow/raw/master/models/EDSR_x2.pb
wget https://github.com/Saafke/EDSR_Tensorflow/raw/master/LICENSE -O edsr_license
wget https://huggingface.co/spaces/CompVis/stable-diffusion-license/blob/main/license.txt -O sdhf_license
wget https://github.com/ChenyangSi/FreeU/raw/main/LICENSE -O freeu_license
check_disk_space

echo "Installation terminée."
