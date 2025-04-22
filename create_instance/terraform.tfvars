## Copyright (c) 2023, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

# Tenancy
tenancy_ocid = "ocid1.tenancy.oc1..aaaaaaaaojcizdygp3su6uricqytroqr2ufcprejd7o4earwmbz3akr5ka4q"

# Region - should be the home region
region = "us-ashburn-1"

# Instance details
instance_shape                      = "VM.Standard.A2.Flex"
instance_ocpus                      = 1
instance_shape_config_memory_in_gbs = 6
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




