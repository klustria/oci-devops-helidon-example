## Copyright (c) 2023, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

# Create policies for deployment host instance
resource "oci_identity_policy" "instance_policy" {
  name           = "instance-policy${local.resource_name_random_suffix}"
  description    = "Policy created for compute instance that will host the deployment"
  compartment_id = var.tenancy_ocid

  statements = [
    "Allow dynamic-group ${oci_identity_dynamic_group.instance_dynamic_group.name} to use instance-agent-command-execution-family in compartment ${oci_identity_compartment.compartment.name}",
    "Allow dynamic-group ${oci_identity_dynamic_group.instance_dynamic_group.name} to read generic-artifacts in compartment ${oci_identity_compartment.compartment.name}",
    "Allow dynamic-group ${oci_identity_dynamic_group.instance_dynamic_group.name} to use log-content in compartment ${oci_identity_compartment.compartment.name}",
    "Allow dynamic-group ${oci_identity_dynamic_group.instance_dynamic_group.name} to use metrics in compartment ${oci_identity_compartment.compartment.name}",
    "Allow dynamic-group ${oci_identity_dynamic_group.instance_dynamic_group.name} to manage objects in compartment ${oci_identity_compartment.compartment.name}",
    "Allow dynamic-group ${oci_identity_dynamic_group.instance_dynamic_group.name} to use buckets in compartment ${oci_identity_compartment.compartment.name}"
  ]
}
