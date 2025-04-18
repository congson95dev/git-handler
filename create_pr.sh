#!/bin/bash

# List of repository folders
PREFIX_FOLDER="mac"
REPO_FOLDERS=("rosemary-frontend" "lifescience_backend" "lifescience-operator-management-backend" "lifescience_bff" "lifescience-operator-management-bff" "lifescience-worker")

# Tag and message
BASE_BRANCH="main"
FEATURE_BRANCH="develop"
PR_TITLE="Merge "$FEATURE_BRANCH" to "$BASE_BRANCH""
PR_BODY="# Description

Merge develop branch to main branch

## Type of change

- [x] New feature (non-breaking change which adds functionality)
- [x] This change requires a documentation update

# How Has This Been Tested?

Tested on development environment

# Checklist:

- [x] My code follows the style guidelines of this project
- [x] I have performed a self-review of my code
- [x] I have commented my code, particularly in hard-to-understand areas
- [x] I have made corresponding changes to the documentation
- [x] My changes generate no new warnings
- [x] I have added tests that prove my fix is effective or that my feature works
- [x] New and existing unit tests pass locally with my changes
- [x] Any dependent changes have been merged and published in downstream modules"

PR_LINKS=()

for REPO in "${REPO_FOLDERS[@]}"; do
    echo "*** Creating PR for $REPO..."

    cd "../"
    cd "$PREFIX_FOLDER/$REPO"
    git fetch

    if [[ $REPO == *"rosemary-frontend"* ]]; then
        FEATURE_BRANCH="ls-develop"
        git reset --h
    else
        FEATURE_BRANCH="develop"
    fi
    
    
    git checkout "$FEATURE_BRANCH"
    git pull origin "$FEATURE_BRANCH"
    PR_OUTPUT=$(gh pr create --base "$BASE_BRANCH" --head "$FEATURE_BRANCH" --title "$PR_TITLE" --body "$PR_BODY" 2>&1)
    echo "$PR_OUTPUT"
    cd "../"
    
    # Throw error if failed
    if [ $? -ne 0 ]; then
        echo "Error processing $REPO. Skipping to next repository."
        PR_LINKS+=("$REPO: Failed to create PR")
        continue
    fi

    # Organize the created PRs
    PR_URL=$(echo "$PR_OUTPUT" | grep -Eo 'https://github.com/[a-zA-Z0-9._-]+/[a-zA-Z0-9._-]+/pull/[0-9]+')
    PR_LINKS+=("$REPO: $PR_URL")
done

# Print a summary of all PRs
echo -e "\nSummary of Pull Requests:"
for LINK in "${PR_LINKS[@]}"; do
    echo "- $LINK"
done