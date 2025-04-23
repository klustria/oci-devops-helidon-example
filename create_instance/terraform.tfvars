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

# Tenancy
tenancy_ocid = "ocid1.tenancy.oc1..aaaaaaaaojcizdygp3su6uricqytroqr2ufcprejd7o4earwmbz3akr5ka4q"

# Region - should be the home region
region = "us-ashburn-1"

# Instance details
instance_shape                      = "VM.Standard.E2.1.Micro"
instance_ocpus                      = 1
instance_shape_config_memory_in_gbs = 1
instance_os                         = "Oracle Linux"
instance_os_version                 = "8"

# Set values for below variables only under the following conditions:
# 1. If using user principal authentication. Set the proper user credentials and uncomment corresponding provider
#    parameters in providers.tf.
# 2. If user needs additional policy to access the created compartment and cloud shell, which in this scenario, needs
#    only "user_ocid" to be set up.
#
# user_ocid        = "ocid1.user.oc1.."
# fingerprint      = "1c.."
# private_key_path = "~/.oci/oci_api_key.pem"




