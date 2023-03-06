#!/bin/bash

# Suche nach allen Bash-Skripten im Repository
files=$(find . -name "*.sh")

# Durchsuche jedes Skript nach Befehlen und formatiere sie als Markdown
for file in $files; do
  commands=$(grep -E "# Execute command:.*" "$file" | sed 's/# Execute command:    //g')
  if [ ! -z "$commands" ]; then
    echo "### $(basename "$file")" >> commands.md
    echo "\`\`\`bash" >> commands.md
    echo "$commands" >> commands.md
    echo "\`\`\`" >> commands.md
    echo "" >> commands.md
  fi
done
