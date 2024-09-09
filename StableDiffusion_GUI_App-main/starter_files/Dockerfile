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
    && rm -rf /var/lib/apt/lists/*

# Définir le répertoire de travail dans le conteneur
WORKDIR /app

# Create a non-privileged user that the app will run under.
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    appuser

# Switch to the non-privileged user to run the application.
USER root


# Copier le fichier requirements.txt dans le répertoire de travail
COPY starter_files/requirements.txt /app/

# Installer les dépendances Python
RUN pip install --no-cache-dir -r requirements.txt

# Copier tous les fichiers de l'application dans le répertoire de travail
COPY starter_files/ /app/

# Exposer le port sur lequel l'application écoute
EXPOSE 8000

# Commande pour démarrer l'application
CMD ["python3", "app.py"]
