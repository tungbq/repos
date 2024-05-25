#!/bin/bash

REPOSITORY_LIST=$1
MODE=${2:-table}

# User input, or will be automated detected via CI
GITHUB_OWNER=$3

if [[ -z $REPOSITORY_LIST || -z $MODE || -z $GITHUB_OWNER ]]; then
    echo "ERROR: epository list is empty!"
    echo "Usage: $0 <repository_list_path> <mode> <github_owner>"
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

# Function to generate table rows
generate_repo_table() {
    local index="$1"
    local repo_name="$2"
    local description="$3"


    # Only get base repo name, execlude the username
    repo_base_name=$(basename $repo_name)

    local repo_hyperlink="<a href=\"https://github.com/$repo_name\">$repo_name</a>"
    local stars="<a href=\"https://github.com/$repo_name/stargazers\"><img alt=\"GitHub Repo stars\" src=\"https://img.shields.io/github/stars/$repo_name\"/></a>"

    # At header in the first run
    if [[ "$index" == "1" ]]; then
        # Start HTML table
        echo "<table>" >> README.md
        echo "    <tr>" >> README.md
        echo "        <th>Repo URL</th>" >> README.md
        echo "        <th>Description</th>" >> README.md
        echo "        <th>Stars</th>" >> README.md
        echo "    </tr>" >> README.md
    fi

    echo "    <tr>" >> README.md
    echo "        <td>$repo_hyperlink</td>" >> README.md
    echo "        <td>$description</td>" >> README.md
    echo "        <th>$stars</th>" >> README.md
    echo "    </tr>" >> README.md

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

    if [[ "$MODE" == "table" ]]; then
        # Generate table row with incremental index
        generate_repo_table "$index" "$repo_name" "$description"
    else
        # Generate list with incremental index
        generate_repo_list "$index" "$repo_name" "$description"
    fi

    # Increment index
    ((index++))
done <"$REPOSITORY_LIST"

## Table closing
if [[ "$MODE" == "table" ]]; then
    # End HTML table
    echo "</table>" >> README.md
fi

echo "" >>README.md
echo "For full list of repositories, click [**here**](https://github.com/${GITHUB_OWNER}?tab=repositories&q=&type=&language=&sort=stargazers)." >>README.md
