## Copyright (c) 2023, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

# Output compute instance public ip
output "deployment_instance_public_ip" {
  value = oci_core_instance.compute_instance.public_ip
}

