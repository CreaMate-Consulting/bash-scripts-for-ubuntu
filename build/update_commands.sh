#!/bin/bash
#
# Name:           update_commands.sh
# Description:    This script clones a GitHub repository, updates the commands.md and README.md files with the latest information from .sh scripts in the repository, and creates a pull request with the changes. It checks if the 'bash-scripts-for-ubuntu' directory exists and removes it before cloning the repository. If there are no changes, the script will not create a pull request.
# Author:         OpenAI ChatGPT
# GitHub URI:     https://github.com/openai/
# License:        GPL v3 or later
# License URI:    https://www.gnu.org/licenses/gpl-3.0.de.html
#
# Execute command: wget -O update_commands.sh "https://raw.githubusercontent.com/CreaMate-Consulting/bash-scripts-for-ubuntu/main/build/update_commands.sh" && bash update_commands.sh
#

# Set your GitHub username, repository name, and the branch you want to create the pull request
GITHUB_USERNAME="CreaMate-Consulting"
REPO_NAME="bash-scripts-for-ubuntu"
BRANCH_NAME="update-commands-$(date +%Y%m%d%H%M%S)"

# Remove the directory if it exists
if [ -d "$REPO_NAME" ]; then
  rm -rf "$REPO_NAME"
fi

# Clone the repository
git clone "https://github.com/$GITHUB_USERNAME/$REPO_NAME.git"
cd "$REPO_NAME"

# Create a new branch
git checkout -b "$BRANCH_NAME"

# Run the command extraction and update process (similar to the one in GitHub Actions)
SCRIPTS_DIR="."
echo "" > commands.md

# Find all Ubuntu versions
for ubuntu_version in $(find . -maxdepth 1 -type d ! -path .); do
  echo "<details>" >> commands.md
  echo "  <summary>$ubuntu_version</summary>" >> commands.md
  echo "" >> commands.md

  # Find all subdirectories in the Ubuntu version directory
  for subdirectory in $(find "$ubuntu_version" -maxdepth 1 -type d ! -path "$ubuntu_version"); do
    echo "  ### $(basename "$subdirectory")" >> commands.md
    echo "" >> commands.md

    # Find all .sh files in the subdirectory and iterate through them
    find "$subdirectory" -type f -name "*.sh" | while read -r SCRIPT; do
      # Extract the filename and execute command from each script
      FILENAME=$(grep -oP '(?<=Name:           ).*' "$SCRIPT")
      EXECUTE_CMD=$(grep -oP '(?<=Execute command: ).*' "$SCRIPT")
  
      # Append the extracted information to commands.md
      echo "  - **$FILENAME**:" >> commands.md
      echo "    \`$EXECUTE_CMD\`" >> commands.md
      echo "" >> commands.md
    done
  done

  echo "</details>" >> commands.md
  echo "" >> commands.md
done

# Update the README.md file to include the contents of commands.md
sed -i '/<!-- commands_start -->/,/<!-- commands_end -->/{//!d}' README.md
sed -i '/<!-- commands_start -->/r `grep -v "^/\.git$" commands.md`' README.md

# Commit changes and push the new branch
git config user.email "krapas170@gmail.com"
git config user.name "krapas170"
git add commands.md README.md
git commit -m "Update commands.md and README.md" || exit 0

# If changes exist, push the new branch and create the pull request
git push --set-upstream origin "$BRANCH_NAME"
gh pr create --title "Update commands.md and README.md" --body "This PR updates the commands.md and README.md files with the latest script information."

# Clean up by removing the cloned repository
cd ..
rm -rf "$REPO_NAME"
