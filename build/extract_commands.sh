#!/bin/bash

# Erstellt ein Array mit allen Bash-Skripten im Repository
scripts=($(find . -type f -name "*.sh"))

# Erstellt eine Markdown-Datei und schreibt die Überschrift
echo "# Liste der Befehle" > commands.md

# Schleife durch alle Bash-Skripte
for script in "${scripts[@]}"
do
  # Überprüfen, ob das Skript ausführbar ist
  if [[ -x "$script" ]]; then
    # Extrahieren des Titels aus dem Skriptnamen
    title=$(basename "$script" .sh)

    # Extrahieren aller Befehle aus dem Skript
    commands=$(grep -E "^# Execute command: " "$script" | sed -e "s/# Execute command: //")

    # Fügt den Titel und die Befehle der Markdown-Datei hinzu
    echo "## $title" >> commands.md
    echo "\`\`\`" >> commands.md
    echo "$commands" >> commands.md
    echo "\`\`\`" >> commands.md
  fi
done
