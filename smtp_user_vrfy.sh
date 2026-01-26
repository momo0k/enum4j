#!/usr/bin/env bash
HOST="$1"; USERS="$2"; PORT="${3:-25}"; DOMAIN="${4:-}"; DELAY="${5:-0.5}"
(( $#<2 )) && { echo "Usage: $0 host users [port] [domain] [delay]"; exit 1; }
while IFS= read -r u || [[ -n $u ]]; do
  u="${u%%#*}"; u="${u//[$'\t\r\n ']}" || true; [[ -z $u ]] && continue
  tgt="$u"; [[ -n $DOMAIN ]] && tgt="$u@$DOMAIN"
  payload=$(printf 'EHLO localhost\r\nVRFY %s\r\nQUIT\r\n' "$tgt")
  resp=$(printf "%s" "$payload" | nc -w 5 "$HOST" "$PORT" 2>/dev/null || true)
  vrfy_line=$(printf "%s" "$resp" | awk '/^[0-9]{3}/ {lines[++n]=$0} END{ if(n==0) print "NO RESPONSE"; else if(lines[n]~/^221/){ if(n>=2) print lines[n-1]; else print lines[n]} else print lines[n] }')
  echo "${tgt} : ${vrfy_line}"
  sleep "$DELAY"
done < "$USERS"
