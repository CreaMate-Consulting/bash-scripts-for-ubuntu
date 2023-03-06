#!/bin/bash

# Suche nach Bash-Skripten im Repository und extrahiere Befehle
for script in $(find . -type f -name "*.sh"); do
  # Extrahiere den Skriptnamen aus dem Pfad
  name=$(basename "$script" .sh)

  # Schreibe den Skriptnamen in die Markdown-Datei
  echo "## $name" >> commands.md

  # Suche nach dem Befehl im Skript und schreibe ihn in die Markdown-Datei
  grep "^# Execute command: " "$script" | sed "s/^# Execute command: /- \`/" | sed "s/\$/\`/" >> commands.md

  # Füge eine Leerzeile zwischen den Skripten hinzu
  echo "" >> commands.md
done

# Gebe die extrahierten Befehle aus
echo "Extrahierte Befehle:"
cat commands.md

# Lade die Markdown-Datei als Artefakt hoch
echo "Lade commands.md als Artefakt hoch..."
echo "::set-output name=command-file::commands.md"
