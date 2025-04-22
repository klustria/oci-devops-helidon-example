## Copyright (c) 2023, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

# Output created compartment id
output "compartment_id" {
  value = oci_identity_compartment.compartment.id
}

output "compartment_name" {
  value = oci_identity_compartment.compartment.name
}
