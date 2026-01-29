#!/usr/bin/env bash
TARGET='10.10.10.10'
LOGFILE=$(date -u +'%Y%m%dT%H%M%SZ')'_'${TARGET//./_}'_popimaps.log'

# Tiny friendly scanner: IMAPS first, then POP3S. Outputs appended to $LOGFILE.
echo "== IMAPS scan: $(date -u +'%Y-%m-%dT%H:%M:%SZ')" >> "$LOGFILE"
openssl s_client -connect "${TARGET}:imaps" -crlf 2>&1 >> "$LOGFILE"
# u may want to check curl -k 'imaps://10.10.10.10' --user name:pw -v
# tag0 LOGIN name pw
# tag1 LIST "" "*"
# tag2 SELECT xyz
# tag3 FETCH 1 (BODY[])

echo -e "\n== POP3S scan: $(date -u +'%Y-%m-%dT%H:%M:%SZ')" >> "$LOGFILE"
openssl s_client -connect "${TARGET}:pop3s" -crlf 2>&1 >> "$LOGFILE"
#  -starttls for STARTTLS


echo "Scan complete. Results in $LOGFILE"
