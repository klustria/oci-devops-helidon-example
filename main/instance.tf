## Copyright (c) 2021, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

module "instance-deployment" {
  count                = !var.use_oke_cluster ? 1 : 0
  source               = "./instance"
  availability_domain  = var.availablity_domain_name == "" ? data.oci_identity_availability_domains.ads.availability_domains[0]["name"] : var.availablity_domain_name
  compartment_ocid     = var.compartment_ocid
  resource_name_suffix = local.resource_name_suffix
}
