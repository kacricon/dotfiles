#!/usr/bin/env bash
# PostToolUse hook: exits Claude when loop-sentinel file is detected.
# The prompt instructs Claude to write this file as its very last action.

SENTINEL_FILE=".claude/loop-sentinel"

if [ -f "$SENTINEL_FILE" ]; then
  kill -INT "$PPID" 2>/dev/null || true
fi

exit 0
