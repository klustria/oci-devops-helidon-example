#!/bin/bash
#
# Copyright (c) 2025 Oracle and/or its affiliates.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

SCRIPT_DIR=$(dirname $0)
HELIDON_OCI_MP_APP_ZIP=oci-mp-server.zip
source ${SCRIPT_DIR}/get_common.sh


# Display usage information for this tool.
display_help()
{
  local left_justified_size=24
  echo "Usage: $(basename "$0") [Helidon MP OCI project path]"
}

# Main routine
if [ -z "${1}" ]; then
    display_help
    exit
fi
if [ ! -d "${1}" ]; then
    echo "Error: \"${1}\" is not a valid directory"
    exit 1
fi
SERVER_BIN_DIR="${1}\server\target"
cd "${SERVER_BIN_DIR}" || exit 1

# Assemble the application binary
zip -r "${SCRIPT_DIR}/${HELIDON_OCI_MP_APP_ZIP}" libs oci-mp-server.jar
cd "${SCRIPT_DIR}" || exit 1

# Generate private key file that will be use to ssh or scp to the instance
./get.sh create_ssh_private_key
PRIVATE_IP=$(./get.sh public_ip)

# Upload the file
scp -i private.key oci-mp-server.zip opc@"${PRIVATE_IP}":/home/opc
