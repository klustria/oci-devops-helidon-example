## Copyright (c) 2023, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

# Output compute instance public ip
output "instance_public_ip" {
  value = oci_core_instance.compute_instance.public_ip
}

# Output ssh private key
output "instance_ssh_private_key" {
  value = tls_private_key.public_private_key_pair.private_key_pem
}


