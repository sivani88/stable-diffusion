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
    && rm -rf /var/lib/apt/lists/*

ENV  PYTHONDONTWRITEBYTECODE=1
ENV PYTHONNUMBUFFERED=1    

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

# Télécharger les dépendances en tant qu'étape séparée pour tirer parti du cache Docker
# Utiliser le cache pour /root/.cache/pip afin d'accélérer les builds ultérieurs
# Utiliser un bind mount pour requirements.txt afin d'éviter de le copier dans cette couche

RUN --mount=type=cache,target=/root/.cache/pip \
    --mount=type=bind,source=requirements.txt,target=requirements.txt \
    python -m pip install -r requirements.txt



# Switch to the non-privileged user to run the application.
USER root


# Copier le fichier requirements.txt dans le répertoire de travail
COPY . .

# Installer les dépendances Python
RUN pip install --no-cache-dir -r requirements.txt



# Exposer le port sur lequel l'application écoute
EXPOSE 8000

# Commande pour démarrer l'application
CMD ["python3", "app.py"]
