#!/bin/bash

# Function to generate table rows
generate_table_row() {
    local repo_name="$1"
    local description="$2"

    echo "    <tr>" >> README.md
    echo "        <td><a href=\"https://github.com/$repo_name\">$(basename $repo_name)</a></td>" >> README.md
    echo "        <td>$description</td>" >> README.md
    echo "        <td><a href=\"https://github.com/$repo_name/stargazers\"><img alt=\"GitHub Repo stars\" src=\"https://img.shields.io/github/stars/$repo_name\"/></a></td>" >> README.md
    echo "    </tr>" >> README.md
}

# Start README file with header
echo "<h1 align=\"center\">Tung's Repositories Landscape 💝</h1>" > README.md
echo "<p align=\"center\">Welcome to my repositories landscape 👋</p>" >> README.md

# Start HTML table
echo "<table>" >> README.md
echo "    <tr>" >> README.md
echo "        <th>Repo URL</th>" >> README.md
echo "        <th>Description</th>" >> README.md
echo "        <th>Stars</th>" >> README.md
echo "    </tr>" >> README.md

# Loop through each repository URL
while IFS= read -r repo_name; do
    echo "Working on repo: $repo_name"

    # Make the API request to get repository information
    response=$(curl -s "https://api.github.com/repos/$repo_name")

    # Extract the description from the response using jq (ensure jq is installed)
    description=$(echo "$response" | jq -r '.description')

    # Generate table row
    generate_table_row "$repo_name" "$description"
done < "$1"

# End HTML table
echo "</table>" >> README.md
echo "" >> README.md
echo "For full list of repositories, click [**here**](https://github.com/tungbq?tab=repositories&q=&type=&language=&sort=stargazers)." >> README.md
