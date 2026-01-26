#!/usr/bin/env bash
HOST="${1:-10.10.10.10}"; USERS="${2:-./users}"; PORT="${3:-25}"; DOMAIN="${4:-}"; DELAY="${5:-0.5}"
(( $#<2 )) && { echo "Usage: $0 host users [port] [domain] [delay]"; exit 1; }
while IFS= read -r u || [[ -n $u ]]; do
  u="${u%%#*}"; u="${u//[$'\t\r\n ']}" ; [[ -z $u ]] && continue
  tgt="$u"; [[ -n $DOMAIN ]] && tgt="$u@$DOMAIN"
  payload=$(printf 'EHLO localhost\r\nVRFY %s\r\nQUIT\r\n' "$tgt")
  resp=$(printf "%s" "$payload" | nc -w 5 "$HOST" "$PORT" 2>/dev/null || true)
  line=$(printf "%s" "$resp" | awk '/^[0-9]{3}/ {print; exit}')
  echo "${tgt} : ${line:-NO RESPONSE}"; sleep "$DELAY"; done < "$USERS"
