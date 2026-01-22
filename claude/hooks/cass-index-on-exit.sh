#!/bin/bash
# Index cass sessions on conversation end (clear or Ctrl+C)
# Runs in background to not block exit

# Read the hook input
INPUT=$(cat)

# Extract the reason
REASON=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('reason',''))" 2>/dev/null)

# Only index on clear or Ctrl+C exit
case "$REASON" in
    clear|prompt_input_exit)
        # Run index in background, suppress output
        nohup /home/ubuntu/.local/bin/cass index --json >/dev/null 2>&1 &
        ;;
esac

exit 0
