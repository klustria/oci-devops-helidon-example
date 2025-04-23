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
source "${SCRIPT_DIR}"/get_common.sh


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
CURRENT_DIR=$(pwd)
SERVER_BIN_DIR="${1}/server/target"
cd "${SERVER_BIN_DIR}" || exit 1

# Assemble the application zip
zip -r "${CURRENT_DIR}/${HELIDON_OCI_MP_APP_ZIP}" libs oci-mp-server.jar
cd "${CURRENT_DIR}" || exit 1

# Generate private key file that will be use to ssh or scp to the instance
"${SCRIPT_DIR}"/get.sh create_ssh_private_key
# Get instance public IP
PUBLIC_IP=$("${SCRIPT_DIR}"/get.sh public_ip)
# Upload the application zip
scp -o StrictHostKeyChecking=accept-new -i private.key oci-mp-server.zip opc@"${PUBLIC_IP}":/home/opc
# Download & install jdk and run app
ssh -i private.key opc@"${PUBLIC_IP}" << 'EOF'
    unzip oci-mp-server.zip
    curl -O https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.tar.gz
    tar xvzf jdk-21_linux-x64_bin.tar.gz
    export PATH=~/jdk-21.0.7/bin:$PATH
    nohup java -jar target/oci-mp-server.jar &> ci-mp-server.log &
EOF

# delete private.key
rm private.key
