## Copyright (c) 2021, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

module "oke-deployment" {
  count                = var.use_oke_cluster ? 1 : 0
  source               = "./oke"
  availability_domains = data.oci_identity_availability_domains.ads.availability_domains
  compartment_ocid     = var.compartment_ocid
  k8s_version          = "Latest"
  node_pool_workers    = 1
  resource_name_suffix = local.resource_name_suffix
  ssh_public_key       = var.ssh_public_key == "" ? tls_private_key.public_private_key_pair.public_key_openssh : var.ssh_public_key
}
