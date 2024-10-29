# Utiliser une image de base Python
FROM python:3.11.5-slim

# Installer les dépendances système requises pour certaines bibliothèques Python et Pillow
RUN apt-get update && apt-get install -y \
    gcc \
    libjpeg-dev \
    zlib1g-dev \
    libfreetype6-dev \
    liblcms2-dev \
    libopenjp2-7-dev \
    libtiff5-dev \
    libwebp-dev \
    tcl8.6-dev \
    tk8.6-dev \
    python3-tk \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 \
    nano \
    && rm -rf /var/lib/apt/lists/*

# Définir les variables d'environnement pour éviter l'écriture des fichiers pyc et activer le buffer Python
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Définir le répertoire de travail dans le conteneur
WORKDIR /app

# Créer un utilisateur non-privilégié (optionnel mais conservé)
ARG UID=1000
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    appuser

# Copier le fichier requirements.txt et installer les dépendances en tant qu'étape séparée
COPY requirements.txt .

# Utiliser le cache pour /root/.cache/pip afin d'accélérer les builds ultérieurs
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install -r requirements.txt

# Copier tous les fichiers du répertoire courant dans le répertoire de travail
COPY . .

# Changer l'utilisateur pour root si nécessaire (vous pouvez ajuster selon vos besoins)
USER root

# Exposer le port sur lequel l'application écoute
EXPOSE 8000

# Commande pour démarrer l'application
CMD ["python3", "app.py"]