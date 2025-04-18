#!/bin/bash

# List of repository folders
PREFIX_FOLDER="mac"
REPO_FOLDERS=("lifescience-worker" "lifescience-operator-management-backend" "lifescience_backend" "lifescience-operator-management-bff" "lifescience_bff")
# REPO_FOLDERS=("lifescience_bff")

# Tag and message
TAG="v1.6.0"
MESSAGE=$TAG

for REPO in "${REPO_FOLDERS[@]}"; do
    cd "../"
    cd "$PREFIX_FOLDER/$REPO"
    git fetch
    git checkout main
    git pull origin main
    echo "🔖 Creating tag "$TAG" on $REPO..."
    git tag -a "$TAG" -m "$MESSAGE"
    # Compare commits between main và tag to ensure it's based on main
    if git log main.."$TAG" --oneline | grep .; then
        echo "🚫 Tag '$TAG' contains commits not in 'main'. Aborting push."
        git tag -d "$TAG"
        continue
    else
        echo "✅ Tag '$TAG' is correctly based on 'main'. Proceeding to push."
        git push origin "$TAG"
    fi
    git push origin "$TAG"
    cd "../"
    if [ $? -ne 0 ]; then
        echo "⚠️ Error processing $REPO. Skipping to next repository."
    fi
done

