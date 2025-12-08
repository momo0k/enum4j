#!/usr/bin/env bash

# Fail fast and be strict about errors
# set -e : exit on nonzero exit status
# set -u : exit on unset variable reference
# set -o pipefail : prevent pipeline errors from being masked
# (See http://redsymbol.net/articles/unofficial-bash-strict-mode/)
set -euo pipefail

TARGET=''
LOGFILE='rpcclient_bruteforce.log'
ts=$(date -Is)

set +e
printf '%s RID - queryuser:\n' "$ts" >> "$LOGFILE"
for i in $(seq 500 1100);do rpcclient -N -U "" "$TARGET" -c "queryuser 0x$(printf '%x\n' $i)" >> "$LOGFILE" 2>&1 ;done
# set -e
