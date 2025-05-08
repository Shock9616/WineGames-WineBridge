#!/usr/bin/env bash
# Determine the Resources directory inside the .app bundle
RESOURCES="$(cd "$(dirname "$0")/../Resources" && pwd)"
PYTHON="$RESOURCES/venv/bin/python3"
SCRIPT="$RESOURCES/main.py"
PIDFILE="$RESOURCES/scanner.pid"

# (1) No args → list the menu items
if [ $# -eq 0 ]; then
  echo "Start"
  echo "Stop"
  echo "Show Config File"
  exit 0
fi

# (2) With an arg → perform the chosen action
case "$1" in
  Start)
    # If not already running, launch the scanner in background
    if [ ! -f "$PIDFILE" ] || ! kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
      nohup "$PYTHON" "$SCRIPT" >/dev/null 2>&1 &
      echo $! > "$PIDFILE"
    fi
    ;;
  Stop)
    # If running, terminate the scanner
    if [ -f "$PIDFILE" ]; then
      kill "$(cat "$PIDFILE")" 2>/dev/null
      rm "$PIDFILE"
    fi
    ;;
  "Show Config File")
    open "$RESOURCES"
    ;;
esac
