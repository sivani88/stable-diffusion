#!/bin/bash

# Variables
BRANCH="main"
INCREMENT_FILE=".commit_increment.txt"

# Créer le fichier d'incrémentation s'il n'existe pas
if [ ! -f "$INCREMENT_FILE" ]; then
  echo 1 > "$INCREMENT_FILE"
fi

# Lire le numéro d'incrémentation actuel
INCREMENT=$(cat "$INCREMENT_FILE")

# Ajouter les changements
git add .

# Créer le message de commit avec l'incrément
COMMIT_MESSAGE="Commit automatique #$INCREMENT"

# Faire le commit
git commit -m "$COMMIT_MESSAGE"

# Incrémenter et sauvegarder le nouveau numéro
INCREMENT=$((INCREMENT + 1))
echo $INCREMENT > "$INCREMENT_FILE"

# Pousser vers la branche dev
git push origin "$BRANCH"

echo "Commit et push effectués sur la branche $BRANCH avec le message: '$COMMIT_MESSAGE'"
