#!/bin/bash
# Ultimate Bug Scanner - Claude Code Hook
# Runs on every file save for UBS-supported languages (JS/TS, Python, C/C++, Rust, Go, Java, Ruby)

# Read JSON input from stdin
INPUT=$(cat)

# Extract file_path from the JSON
FILE_PATH=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('file_path',''))" 2>/dev/null)

# Exit if no file path
[[ -z "$FILE_PATH" ]] && exit 0

# Check if it's a supported file type
if [[ "$FILE_PATH" =~ \.(js|jsx|ts|tsx|mjs|cjs|py|pyw|pyi|c|cc|cpp|cxx|h|hh|hpp|hxx|rs|go|java|rb)$ ]]; then
  # Check if ubs is available
  if ! command -v ubs >/dev/null 2>&1; then
    echo "ubs not found in PATH" >&2
    exit 0
  fi

  # Get the project directory (parent of the file)
  PROJECT_DIR=$(dirname "$FILE_PATH")

  echo "Running bug scanner on $FILE_PATH..."
  ubs "$PROJECT_DIR" --ci 2>&1 | head -50
fi

exit 0
