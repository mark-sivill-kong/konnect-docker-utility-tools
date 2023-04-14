#!/bin/bash

# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.

#
# This scripts shows an example of transforming an OpenAPI specification
# into Kong configuration then upload to Konnect. Only services and routes
# are created in Kong Konnect for this example.
#
# This script assumes that the filename passed in is in a specific
# directory, correct command line tooling has been installed, and
# relevant environment variables have been set up
#
# This script has not been designed or tested for production environments
# 

#
# check filename argument passed in
#
if [ -z "${1}" ]
  then
    echo "No OpenAPI specification filename specified"
    exit 1
  else
    OPENAPI_SPECIFICATION_FILENAME=${1}
fi

#
# full path name to openapi spec
#
OPENAPI_SPECIFICATION_PATH_FILENAME=${HOME}/openapi-specs/${OPENAPI_SPECIFICATION_FILENAME}

if [ -f "${OPENAPI_SPECIFICATION_PATH_FILENAME}" ]; then
    echo "${OPENAPI_SPECIFICATION_PATH_FILENAME} exists"
else 
    echo "${OPENAPI_SPECIFICATION_PATH_FILENAME} does not exist"
    echo "File(s) found in OPENAPI_SPECIFICATION_PATH_FILENAME=${HOME}/openapi-specs/"
    for file in ${HOME}/openapi-specs/*; do
        echo "`basename ${file}`"
    done
    exit 1
fi

#
# check environment variables are set up
#

echo "`date` checking environment variables"

if [[ -z "${KONNECT_ADDR}" ]]; then
  echo "`date` KONNECT_ADDR environment variable is undefined"
  exit 1
else
  echo "`date` KONNECT_ADDR environment variable is defined"
fi

if [[ -z "${KONNECT_PAT}" ]]; then
  echo "`date` KONNECT_PAT environment variable is undefined"
  exit 1
else
  echo "`date` KONNECT_PAT environment variable is defined"
fi

if [[ -z "${KONNECT_RUNTIME_GROUP}" ]]; then
  echo "`date` KONNECT_RUNTIME_GROUP environment variable is undefined"
  exit 1
else
  echo "`date` KONNECT_RUNTIME_GROUP environment variable is defined"
fi


#
# define other variables
#

TIMESTAMP=$( date '+%Y%m%d%H%M%S' )

# output directory
OUTPUT_DIRECTORY=${HOME}/output/${TIMESTAMP}
mkdir ${OUTPUT_DIRECTORY}

# working openapi specification in yaml
OPENAPI_SPECIFICATION_FILENAME_YAML=${OUTPUT_DIRECTORY}/openapi-spec.yaml

# kong tags
KONG_TAGS=generated,${OPENAPI_SPECIFICATION_FILENAME}

#
# convert OpenAPI spec to Kong configuration
#

# optional check
echo "`date` checking OpenAPI specification is valid for ${OPENAPI_SPECIFICATION_PATH_FILENAME}"
inso lint spec ${OPENAPI_SPECIFICATION_PATH_FILENAME}

# optional, convert into yaml for further processing
echo "`date` save OpenAPI specification ${OPENAPI_SPECIFICATION_PATH_FILENAME} as yaml ${OPENAPI_SPECIFICATION_FILENAME_YAML}"
npx openapi-format ${OPENAPI_SPECIFICATION_PATH_FILENAME} --yaml > ${OPENAPI_SPECIFICATION_FILENAME_YAML}

echo "`date` generating kong configuration for ${OPENAPI_SPECIFICATION_FILENAME_YAML}"
inso generate config ${OPENAPI_SPECIFICATION_FILENAME_YAML} --tags "${KONG_TAGS}" -o ${OUTPUT_DIRECTORY}/kong-v2.yaml
cat ${OUTPUT_DIRECTORY}/kong-v2.yaml

echo "`date` upgrading kong configuration to version 3 for ${OUTPUT_DIRECTORY}/kong-v2.yaml"
deck convert --from kong-gateway-2.x --to kong-gateway-3.x --input-file ${OUTPUT_DIRECTORY}/kong-v2.yaml --output-file ${OUTPUT_DIRECTORY}/kong-v3.yaml
cat ${OUTPUT_DIRECTORY}/kong-v3.yaml

# optional check
echo "`date` validate kong configuration for ${OUTPUT_DIRECTORY}/kong-v3.yaml"
deck validate --verbose 2 --state ${OUTPUT_DIRECTORY}/kong-v3.yaml

#
# example of changing generated kong configuration
# remove some generated tags 
#
yq eval 'del(.. | .tags? | .[] | select( . == "OAS3_import" ))' ${OUTPUT_DIRECTORY}/kong-v3.yaml > ${OUTPUT_DIRECTORY}/kong-mod1.yaml
yq eval 'del(.. | .tags? | .[] | select( . == "OAS3file_openapi-spec.yaml" ))' ${OUTPUT_DIRECTORY}/kong-mod1.yaml > ${OUTPUT_DIRECTORY}/kong-mod-final.yaml


# optional check
echo "`date` validate modified kong configuration for ${OUTPUT_DIRECTORY}/kong-mod-final.yaml"
deck validate --verbose 2 --state ${OUTPUT_DIRECTORY}/kong-mod-final.yaml


#
# upload kong configuration to konnect
#

# optional check
echo "`date` check we can reach konnect"
deck ping --verbose 2 --konnect-addr ${KONNECT_ADDR} --konnect-runtime-group-name ${KONNECT_RUNTIME_GROUP} --konnect-token ${KONNECT_PAT}

echo "`date` backup current kong configuration to ${OUTPUT_DIRECTORY}/kong-backup.yaml"
deck dump -o ${OUTPUT_DIRECTORY}/kong-backup.yaml --konnect-addr ${KONNECT_ADDR} --konnect-runtime-group-name ${KONNECT_RUNTIME_GROUP} --konnect-token ${KONNECT_PAT}
cat ${OUTPUT_DIRECTORY}/kong-backup.yaml

# optional check
echo "`date` check for difference between current Konnect configuration and ${OUTPUT_DIRECTORY}/kong-mod-final.yaml"
deck diff --state ${OUTPUT_DIRECTORY}/kong-mod-final.yaml --konnect-addr ${KONNECT_ADDR} --konnect-runtime-group-name ${KONNECT_RUNTIME_GROUP} --konnect-token ${KONNECT_PAT} --select-tag "${KONG_TAGS}" 

echo "`date` sync generated kong configuration with ${OUTPUT_DIRECTORY}/kong-mod-final.yaml"
deck sync --state ${OUTPUT_DIRECTORY}/kong-mod-final.yaml --konnect-addr ${KONNECT_ADDR} --konnect-runtime-group-name ${KONNECT_RUNTIME_GROUP} --konnect-token ${KONNECT_PAT} --select-tag "${KONG_TAGS}" 

# optional check
echo "`date` check that there are no differences between current Konnect configuration and ${OUTPUT_DIRECTORY}/kong-mod-final.yaml"
deck diff --state ${OUTPUT_DIRECTORY}/kong-mod-final.yaml --konnect-addr ${KONNECT_ADDR} --konnect-runtime-group-name ${KONNECT_RUNTIME_GROUP} --konnect-token ${KONNECT_PAT} --select-tag "${KONG_TAGS}" 

#
# wrap up, show generated files
#

# optional check
echo "`date` files in ${OUTPUT_DIRECTORY}"
ls -al ${OUTPUT_DIRECTORY}

