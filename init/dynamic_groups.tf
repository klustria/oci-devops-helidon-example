## Copyright (c) 2023, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

# Create group, user and policies
resource "oci_identity_dynamic_group" "instance_dynamic_group" {
  name           = "instance-dynamic-group${local.resource_name_random_suffix}"
  description    = "Compute instance dynamic group"
  compartment_id = var.tenancy_ocid
  matching_rule  = "ALL {instance.compartment.id = '${oci_identity_compartment.compartment.id}'}"
}
