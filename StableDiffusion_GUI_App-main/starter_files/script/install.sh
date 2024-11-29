#!/bin/bash

# Arrêter l'exécution en cas d'erreur
set -e

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
sudo apt-get update
sudo apt-get install -y gnupg

check_disk_space

# Ajout de la clé GPG officielle de Docker
echo "Ajout de la clé GPG officielle de Docker..."
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

# Ajout du référentiel Docker pour Debian
echo "Ajout du référentiel Docker..."
echo "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Mise à jour des paquets après ajout du référentiel Docker
echo "Mise à jour des paquets après ajout du référentiel Docker..."
sudo apt-get update
check_disk_space

# Installation de Docker
echo "Installation de Docker..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
check_disk_space

# Ajout de l'utilisateur actuel au groupe Docker
echo "Ajout de l'utilisateur actuel au groupe Docker..."
sudo usermod -aG docker ${USER}

# Ajout de azureuser au groupe root
echo "Ajout de azureuser au groupe root..."
sudo usermod -aG root azureuser

# Redémarrage du service Docker pour s'assurer qu'il fonctionne
echo "Démarrage du service Docker..."
sudo systemctl start docker
sudo systemctl enable docker

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

# Supprimer le dépôt existant avant de cloner


# Clonage du dépôt GitHub
echo "Clonage du dépôt GitHub..."
git clone https://github.com/sivani88/stable-diffusion.git
check_disk_space

# Accès au répertoire racine du projet
cd ~/stable-diffusion/StableDiffusion_GUI_App-main/starter_files || exit 1

# Installation de Git LFS et téléchargement du modèle Stable Diffusion
echo "Installation de Git LFS..."
sudo apt-get install -y git-lfs
git-lfs install

# Supprimer le répertoire du modèle existant avant de cloner
rm -rf stable-diffusion-v1-4
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
wget https://huggingface.co/spaces/CompVis/stable-diffusion-license/blob/main/license.txt -O sdhf_license
wget https://github.com/ChenyangSi/FreeU/raw/main/LICENSE -O freeu_license
check_disk_space

echo "Installation terminée."
echo "Veuillez redémarrer votre session pour appliquer les changements de groupe Docker et root."