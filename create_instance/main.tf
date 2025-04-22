## Copyright (c) 2025, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

module "tenancy" {
  source               = "./tenancy"
  tenancy_ocid         = var.tenancy_ocid
  resource_name_suffix = local.resource_name_suffix
}

module "instance-deployment" {
  source                  = "./instance"
  availablity_domain_name = var.availablity_domain_name == "" ?
    data.oci_identity_availability_domains.ads.availability_domains[0]["name"] : var.availablity_domain_name
  ssh_public_key                      = var.ssh_public_key
  compartment_ocid                    = module.tenancy.compartment_id
  resource_name_suffix                = local.resource_name_suffix
  instance_shape                      = var.instance_shape
  instance_ocpus                      = var.instance_ocpus
  instance_shape_config_memory_in_gbs = var.instance_shape_config_memory_in_gbs
  instance_os                         = var.instance_os
  instance_os_version                 = var.instance_os_version

}
