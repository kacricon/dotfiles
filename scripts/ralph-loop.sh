#!/usr/bin/env bash
set -euo pipefail

MAX_ITERATIONS="${MAX_ITERATIONS:-20}"
COOLDOWN="${COOLDOWN:-5}"
PROMPT_FILE="${1:-prompt.md}"
SENTINEL_FILE=".claude/loop-sentinel"

iteration=0
while [ "$iteration" -lt "$MAX_ITERATIONS" ]; do
  iteration=$((iteration + 1))

  echo "=== Iteration $iteration / $MAX_ITERATIONS ==="

  # Clean sentinel from previous iteration
  rm -f "$SENTINEL_FILE"

  # Run Claude with TUI visible; hook exits session when sentinel file appears
  claude --dangerously-skip-permissions "$(cat "$PROMPT_FILE")" || true

  # Read sentinel file left by Claude
  if [ ! -f "$SENTINEL_FILE" ]; then
    echo "Warning: no sentinel file found. Claude may have exited unexpectedly."
    sleep "$COOLDOWN"
    continue
  fi

  sentinel=$(cat "$SENTINEL_FILE")
  rm -f "$SENTINEL_FILE"

  case "$sentinel" in
    IN-SPEC)
      echo "All specs implemented. Stopping."
      exit 0
      ;;
    STUCK)
      echo "Agent is stuck. Check recent commits and specs."
      exit 1
      ;;
    COMPLETE)
      echo "Task complete. Next iteration in ${COOLDOWN}s..."
      sleep "$COOLDOWN"
      continue
      ;;
    *)
      echo "Unknown sentinel: $sentinel. Continuing..."
      sleep "$COOLDOWN"
      ;;
  esac
done

echo "Reached max iterations ($MAX_ITERATIONS). Stopping."
exit 1
