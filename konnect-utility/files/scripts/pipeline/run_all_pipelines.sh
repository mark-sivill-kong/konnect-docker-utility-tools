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
# transform all OpenAPI specification files then upload into Kong Konnect
# for all files found in openapi-specs directory
#

# capture current directory
PARENT_DIRECTORY=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

# directory where all scripts are located
OPENAPI_SPECIFICATION_PATH_FILENAME=${HOME}/openapi-specs/

# Get a list of all files in the directory
files=$(ls "${OPENAPI_SPECIFICATION_PATH_FILENAME}")

# Loop through each file and pass it to another script
for file in $files
do
  ${PARENT_DIRECTORY}/run_pipeline.sh "$file"
done

