## Copyright (c) 2021, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

module "oci-oke" {
  count                = var.create_new_oke_cluster ? 1 : 0
  source               = "./oke"
  availability_domains = data.oci_identity_availability_domains.ads.availability_domains
  compartment_ocid     = var.compartment_ocid
  k8s_version          = "Latest"
  node_pool_workers    = 3
}
