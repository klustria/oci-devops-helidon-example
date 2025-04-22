## Copyright (c) 2023, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

# Output private key used for ssh connection to the provisioned instance
output "generated_ssh_private_key" {
  value     = tls_private_key.public_private_key_pair.private_key_pem
  sensitive = true
}

# Output compute instance public ip
output "deployment_instance_public_ip" {
  value = module.instance-deployment[0].deployment_instance_public_ip
}
