#!/usr/bin/env bash
# Short rpcclient RID enumerator (queryuser + querygroup)
#

set -euo pipefail

TARGET=""
START=500
END=1100
RPCUSER=""    # passed to -U (empty string like your original)
LOGFILE="rpcclient_bruteforce.log"

# start fresh logfile (overwrite)
: > "$LOGFILE"

for i in $(seq "$START" "$END"); do
  hx=$(printf '%x' "$i")
  ts=$(date -Is)

  printf '%s RID %d (0x%s) - queryuser:\n' "$ts" "$i" "$hx" >> "$LOGFILE"
  rpcclient -N -U "$RPCUSER" "$TARGET" -c "queryuser 0x${hx}" >> "$LOGFILE" 2>&1
  printf '\n' >> "$LOGFILE"

  printf '%s RID %d (0x%s) - querygroup:\n' "$ts" "$i" "$hx" >> "$LOGFILE"
  rpcclient -N -U "$RPCUSER" "$TARGET" -c "querygroup 0x${hx}" >> "$LOGFILE" 2>&1
  printf '\n' >> "$LOGFILE"
done
