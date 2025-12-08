#!/usr/bin/env bash

set -euo pipefail

TARGET=""
LOGFILE="rpcclient_bruteforce.log"
ts=$(date -Is)

printf '%s RID - queryuser:\n' "$ts" >> "$LOGFILE"
for i in $(seq 500 1100);do rpcclient -N -U "" "$TARGET" -c "queryuser 0x$(printf '%x\n' $i)" >> "$LOGFILE" 2>&1 ;done
