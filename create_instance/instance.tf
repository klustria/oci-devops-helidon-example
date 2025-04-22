## Copyright (c) 2021, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

module "instance-deployment" {
  source                              = "./instance"
  availablity_domain_name             = var.availablity_domain_name == "" ? data.oci_identity_availability_domains.ads.availability_domains[0]["name"] : var.availablity_domain_name
  ssh_public_key                      = var.ssh_public_key == "" ? tls_private_key.public_private_key_pair.public_key_openssh : var.ssh_public_key
  compartment_ocid                    = oci_identity_compartment.compartment.compartment_id
  resource_name_suffix                = local.resource_name_suffix
  instance_shape                      = "VM.Standard.A2.Flex"
  instance_ocpus                      = 1
  instance_shape_config_memory_in_gbs = 6
}
