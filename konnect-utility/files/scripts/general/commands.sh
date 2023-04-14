#!/bin/bash

#
#  show example deck commands with konnect
#

echo
echo "Example commands"
echo "================"
echo
echo "deck ping --konnect-addr \${KONNECT_ADDR} --konnect-token \${KONNECT_LOCAL_PAT} --verbose 2"
echo "deck dump --konnect-addr \${KONNECT_ADDR} --konnect-runtime-group-name \${KONNECT_RUNTIME_GROUP} --konnect-token \${KONNECT_LOCAL_PAT} --with-id"
echo "deck diff --konnect-addr \${KONNECT_ADDR} --konnect-runtime-group-name \${KONNECT_RUNTIME_GROUP} --konnect-token \${KONNECT_LOCAL_PAT}"
echo "deck sync --state kong.yaml --konnect-addr \${KONNECT_ADDR} --konnect-runtime-group-name \${KONNECT_RUNTIME_GROUP} --konnect-token \${KONNECT_LOCAL_PAT}"
echo


