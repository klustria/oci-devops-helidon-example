## Copyright (c) 2023, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

# Get list of availability domains
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

# Get compute image
data "oci_core_images" "compute_instance_images" {
  compartment_id           = var.compartment_ocid
  operating_system         = var.instance_os
  operating_system_version = var.linux_os_version

  shape      = var.instance_shape
  sort_by    = "TIMECREATED"
  sort_order = "DESC"
}

# Get object storage namespace
data "oci_objectstorage_namespace" "object_storage_namespace" {
  #Optional
  compartment_id = var.compartment_ocid
}

# Used By OKE

# Gets kubeconfig
data "oci_containerengine_cluster_kube_config" "oke_cluster_kube_config" {
  # cluster_id = var.create_new_oke_cluster ? module.oci-oke[0].cluster.id : var.existent_oke_cluster_id
  cluster_id = var.create_new_oke_cluster ? oci_containerengine_cluster.oci_oke_cluster.id : var.existent_oke_cluster_id
}

# Gets a list of supported images based on the shape, operating_system and operating_system_version provided
data "oci_core_images" "node_pool_images" {
  compartment_id           = var.compartment_ocid
  operating_system         = var.node_pool_image_operating_system
  operating_system_version = var.node_pool_image_operating_system_version
  shape                    = var.node_pool_shape
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

data "oci_containerengine_cluster_option" "oke" {
  cluster_option_id = "all"
}
data "oci_containerengine_node_pool_option" "oke" {
  node_pool_option_id = "all"
  compartment_id      = var.compartment_ocid
}

# OCI Services - Available Services
data "oci_core_services" "all_services" {
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}
