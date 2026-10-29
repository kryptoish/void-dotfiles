#!/usr/bin/env bash
# Runs waybar under a supervisor: if it crashes it's restarted, and every
# run's output plus its exit reason is appended to waybar.log.

LOG="$HOME/.config/waybar/waybar.log"
PIDFILE="${XDG_RUNTIME_DIR:-/tmp}/waybar-launch.pid"

# Replace any existing supervisor/waybar so we never end up with two bars
[ -f "$PIDFILE" ] && kill "$(cat "$PIDFILE")" 2>/dev/null
echo $$ > "$PIDFILE"
pkill -x waybar 2>/dev/null
sleep 0.3

# Keep the log from growing forever
if [ -f "$LOG" ] && [ "$(stat -c %s "$LOG")" -gt 1048576 ]; then
    tail -n 2000 "$LOG" > "$LOG.tmp" && mv "$LOG.tmp" "$LOG"
fi

trap 'pkill -x waybar; exit 0' TERM INT

while true; do
    echo "===== waybar started $(date '+%F %T') =====" >> "$LOG"
    waybar >> "$LOG" 2>&1 &
    wait $!
    code=$?
    if [ "$code" -gt 128 ]; then
        reason="killed by signal $((code - 128)) ($(kill -l $((code - 128)) 2>/dev/null))"
    else
        reason="exit code $code"
    fi
    {
        echo "===== waybar exited $(date '+%F %T'): $reason ====="
        echo "      mem: $(free -m | awk '/Mem:/ {print $3"M used / "$7"M avail"}')"
    } >> "$LOG"
    # Exit 0 / SIGTERM = closed on purpose (e.g. pkill), don't respawn
    [ "$code" -eq 0 ] || [ "$code" -eq 143 ] && break
    sleep 1
done
