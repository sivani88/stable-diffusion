#!/bin/bash

# Fichier pour stocker le compteur de commits
COUNTER_FILE=".commit_counter"

# Initialiser le compteur à 1 si le fichier n'existe pas
if [ ! -f "$COUNTER_FILE" ]; then
  echo 1 > "$COUNTER_FILE"
fi

# Lire le compteur actuel
COUNTER=$(cat "$COUNTER_FILE")

# Incrémenter le compteur
NEW_COUNTER=$((COUNTER + 1))

# Mettre à jour le fichier avec le nouveau compteur
echo $NEW_COUNTER > "$COUNTER_FILE"

# Commandes Git
git add .
git commit -m "Commit numéro $COUNTER"
git push origin

# Afficher un message de confirmation
echo "Commit numéro $COUNTER effectué et poussé sur origin."
