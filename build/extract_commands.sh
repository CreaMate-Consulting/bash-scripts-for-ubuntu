#!/bin/bash

# Find all .sh files in the repository
sh_files=$(find . -type f -name "*.sh")

# Remove existing commands.md file
rm -f commands.md

# Loop through each file and extract commands
for file in $sh_files
do
  # Get the script name
  script_name=$(grep -Po '(?<=^# Name:\s{11})(.*)' "$file")

  # Print script name to commands.md
  echo "# $script_name" >> commands.md
  echo "" >> commands.md

  # Extract commands and print to commands.md
  commands=$(grep -Po '(?<=^# Execute command:\s{4}).*' "$file")
  echo "Command:" >> commands.md
  echo "\`\`\`" >> commands.md
  echo "$commands" >> commands.md
  echo "\`\`\`" >> commands.md
  echo "" >> commands.md
done

# Display the extracted commands
cat commands.md
