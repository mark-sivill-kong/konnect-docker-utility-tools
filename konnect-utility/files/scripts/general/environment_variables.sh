#!/bin/bash

#
#  check environment variables
#

echo
echo "Environment variables"
echo "====================="

if [[ -z "${KONNECT_ADDR}" ]]; then
  echo "KONNECT_ADDR environment variable is undefined"
else
  echo "KONNECT_ADDR environment variable is defined"
fi

if [[ -z "${KONNECT_PAT}" ]]; then
  echo "KONNECT_PAT environment variable is undefined"
else
  echo "KONNECT_PAT environment variable is defined"
fi

if [[ -z "${KONNECT_RUNTIME_GROUP}" ]]; then
  echo "KONNECT_RUNTIME_GROUP environment variable is undefined"
else
  echo "KONNECT_RUNTIME_GROUP environment variable is defined"
fi

echo
