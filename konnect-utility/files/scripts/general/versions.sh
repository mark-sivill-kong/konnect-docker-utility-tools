#!/bin/bash

#
#  show versions of tooling installed
#

echo
echo "Tooling versions"
echo "================"
echo
echo "deck - `deck version`"               # kong tooling
echo
echo "inso - `inso --version`"             # kong tooling
echo
echo "yq - `yq --version`" 
echo
echo "jq - `jq --version`" 
echo
echo "openapi-format - `openapi-format --version`" 
echo
echo "kced - `kced version`"               # https://github.com/Kong/go-apiops
echo
echo "curl - `curl --version | head -n 1`" 
echo
echo "wget - `wget -V | head -n 1`"
echo
echo "node - `node -v`"
echo



