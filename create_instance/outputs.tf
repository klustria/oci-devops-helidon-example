## Copyright (c) 2023, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

# Output created compartment id
output "compartment_id" {
  value = module.tenancy.compartment_id
}

# Output created compartment name
output "compartment_name" {
  value = module.tenancy.compartment_name
}

# Output private key used for ssh connection to the provisioned instance
output "instance_ssh_private_key" {
  value     = module.instance.instance_ssh_private_key
  sensitive = true
}

# Output compute instance public ip
output "instance_public_ip" {
  value = module.instance.instance_public_ip
}
