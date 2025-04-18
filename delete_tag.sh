#!/bin/bash

# List of repository folders
PREFIX_FOLDER="mac"
# REPO_FOLDERS=("rosemary-frontend")
REPO_FOLDERS=("lifescience_bff")

TAGS=("v1.6.0-test")

for REPO in "${REPO_FOLDERS[@]}"; do
    for TAG in "${TAGS[@]}"; do
        echo "Deleting tag "$TAG" on $REPO..."
        (
            cd "../"
            cd "$PREFIX_FOLDER/$REPO"
            git fetch
            git reset --h
            git checkout main
            git push --delete origin "$TAG"
            git tag -d "$TAG"
            cd "../"
        )
        if [ $? -ne 0 ]; then
            echo "Error processing $REPO. Skipping to next repository."
        fi
    done
done
