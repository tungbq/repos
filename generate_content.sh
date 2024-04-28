#!/bin/bash

REPOSITORY_LIST=$1

if [ -z $REPOSITORY_LIST ]; then
    echo "ERROR: epository list is empty!"
    echo "Usage: $0 <repository_list_path>"
    exit 1
fi

# Function to generate table rows
generate_repo_list() {
    local index="$1"
    local repo_name="$2"
    local description="$3"

    # Only get base repo name, execlude the username
    repo_base_name=$(basename $repo_name)

    local repo_hyperlink="<a href=\"https://github.com/$repo_name\">$repo_name</a>"
    local stars="<a href=\"https://github.com/$repo_name/stargazers\"><img alt=\"GitHub Repo stars\" src=\"https://img.shields.io/github/stars/$repo_name\"/></a>"

    echo "## $index. $repo_base_name" >>README.md
    echo "- URL: $repo_hyperlink" >>README.md
    echo "- Description: $description" >>README.md
    echo "- $stars" >>README.md
}

# Start README file with header
echo "<h1 align=\"center\">Repositories Landscape 💎</h1>" >README.md
echo "<p align=\"center\">Welcome to my repositories landscape 👋</p>" >>README.md
echo "" >>README.md
echo "If you want to create your own repository landscape similar to this, please follow this [**guide**](./create-repo-landscape.md) 📖" >>README.md
## Seperator to create following list
echo "" >>README.md

# Start with index 1 for first repo
index=1

while IFS= read -r repo_name; do
    echo "Working on repo: $repo_name, with index: $index"

    # Make the API request to get repository information
    response=$(curl -s "https://api.github.com/repos/$repo_name")
    echo "Response:"
    echo "$response"

    # Extract the description from the response using jq (ensure jq is installed)
    description=$(echo "$response" | jq -r '.description')

    # Generate table row with incremental index
    generate_repo_list "$index" "$repo_name" "$description"

    # Increment index
    ((index++))
done <"$REPOSITORY_LIST"

echo "" >>README.md
echo "For full list of repositories, click [**here**](https://github.com/tungbq?tab=repositories&q=&type=&language=&sort=stargazers)." >>README.md
