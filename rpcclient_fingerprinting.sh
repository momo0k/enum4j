#!/usr/bin/env bash
# rpcclient one-liners driven from an array and appending output with >>.
# Useful rpcclient commands for fingerprinting during a pentest.
#
# Replace placeholders:
#   USER        -> username
#   PASS        -> password (can be empty '')
#   DOMAIN      -> optional domain (leave empty if not used)
#   TARGET      -> hostname or IP of the target SMB server
#   SHARE       -> share name (e.g. C$ or IPC$)
#   RID         -> numeric RID of the user (e.g. 1001)
#   NAME        -> username or machine name to resolve (for lookupnames)
#   SID         -> SID to resolve (for lookupsids)
#   GROUP       -> group name (for querygroup/querygroupmem)
#   OUTPUT_FILE -> path to file where output will be appended
#
# Notes:
# - Commands are stored in the cmds array. Use placeholders {SHARE}, {RID},
#   {NAME}, {SID}, and {GROUP} where appropriate; they will be replaced at runtime.
# - Each rpcclient invocation is executed as a one-liner and appends both stdout
#   and stderr to OUTPUT_FILE using >> "$OUTPUT_FILE" 2>&1.
# - For domain accounts use: -U 'DOMAIN\\USER%PASS' (backslash escaped).
#
# Example usage:
#   Edit the variables below then run: ./rpcclient_oneliners.sh

USER='USER'
PASS='PASS'
DOMAIN=''         # e.g. DOMAIN (leave empty if not used)
TARGET='TARGET'   # hostname or IP
SHARE='SHARE'
RID='RID'
NAME='NAME'       # name to resolve with lookupnames
SID='S-1-5-21-...' # SID to resolve with lookupsids
GROUP='GROUP'     # group name for group queries
OUTPUT_FILE='rpcclient_output.log'

# Build -U value (use DOMAIN\\USER%PASS when DOMAIN is set)
if [ -n "$DOMAIN" ]; then
  U="${DOMAIN}\\${USER}%${PASS}"
else
  U="${USER}%${PASS}"
fi

# Array of rpcclient commands (use placeholders where needed)
cmds=(
  'srvinfo'                      # Server information.
  'getusername'                  # Show the username rpcclient is using (fingerprint session context).
  'enumdomains'                  # Enumerate all domains deployed in the network.
  'querydominfo'                 # Domain, server, and user information of deployed domains.
  'getdompwinfo'                 # Get domain password policy / domain password info (useful for policy enumeration).
  'enumtrusts'                   # Enumerate domain trusts (helps map trust relationships).
  'netshareenumall'              # Enumerates all available shares.
  'netsharegetinfo {SHARE}'      # Provides information about a specific share.
  'enumdomusers'                 # Enumerates all domain users.
  'queryuser {RID}'              # Provides information about a specific user by RID.
  'enumdomgroups'                # Enumerates all domain groups (list of groups can reveal roles and accounts).
  'lookupnames {NAME}'           # Resolve a name to SID(s) (useful to map names to SIDs).
  'lookupsids {SID}'             # Resolve a SID to a name (useful to identify built-in or reserved accounts).
  'querygroup {GROUP}'           # Query information about a specific group (replace GROUP).
  'querygroupmem {GROUP}'        # List members of a specific group (good to find privileged accounts).
)

# Run each command as a single rpcclient one-liner and append output.
for c in "${cmds[@]}"; do
  # Replace placeholders with actual variables
  cmd="${c//\{SHARE\}/$SHARE}"
  cmd="${cmd//\{RID\}/$RID}"
  cmd="${cmd//\{NAME\}/$NAME}"
  cmd="${cmd//\{SID\}/$SID}"
  cmd="${cmd//\{GROUP\}/$GROUP}"

  # Make a short log header for readability in the output file
  printf "\n--- rpcclient: %s ---\n" "$cmd" >> "$OUTPUT_FILE"

  # Run rpcclient with the single command on one line and append output
  rpcclient -U "$U" "$TARGET" -c "$cmd" >> "$OUTPUT_FILE" 2>&1
done

# End of script
