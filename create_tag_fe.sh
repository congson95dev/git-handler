#!/bin/bash

# List of repository folders
PREFIX_FOLDER="mac"
REPO="rosemary-frontend"

# Tag and message
MESSAGE="v1.6.0"
TAGS=("ls-insight-${MESSAGE}" "ls-operator-${MESSAGE}")

cd "../"
cd "$PREFIX_FOLDER/$REPO"
git fetch
git reset --h
git checkout main
git pull origin main

for TAG in "${TAGS[@]}"; do
    echo "🔖 Creating tag "$TAG" on $REPO..."
    (
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
    )
    if [ $? -ne 0 ]; then
        echo "⚠️ Error processing $REPO. Skipping to next repository."
    fi
done

