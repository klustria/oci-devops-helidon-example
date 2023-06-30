## Copyright (c) 2021, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

# module "oci-oke" {
#   count                                                                       = var.create_new_oke_cluster ? 1 : 0
#   source                                                                      = "./oke" # "github.com/oracle-quickstart/oci-oke"
#   tenancy_ocid                                                                = var.tenancy_ocid
#   compartment_ocid                                                            = var.compartment_ocid
#   oke_cluster_name                                                            = "oke-cluster${local.resource_name_suffix}"
#   services_cidr                                                               = lookup(var.network_cidrs, "KUBERNETES-SERVICE-CIDR")
#   pods_cidr                                                                   = lookup(var.network_cidrs, "PODS-CIDR")
#   cluster_options_add_ons_is_kubernetes_dashboard_enabled                     = var.cluster_options_add_ons_is_kubernetes_dashboard_enabled
#   cluster_options_add_ons_is_tiller_enabled                                   = false
#   cluster_options_admission_controller_options_is_pod_security_policy_enabled = var.cluster_options_admission_controller_options_is_pod_security_policy_enabled
#   pool_name                                                                   = var.node_pool_name
#   node_shape                                                                  = var.node_pool_shape
#   node_ocpus                                                                  = var.node_pool_node_shape_config_ocpus
#   node_memory                                                                 = var.node_pool_node_shape_config_memory_in_gbs
#   node_count                                                                  = var.num_pool_workers
#   node_pool_boot_volume_size_in_gbs                                           = var.node_pool_boot_volume_size_in_gbs
#   k8s_version                                                                 = (var.k8s_version == "Latest") ? local.cluster_k8s_latest_version : var.k8s_version
#   use_existing_vcn                                                            = true
#   vcn_id                                                                      = oci_core_virtual_network.oke_vcn[0].id
#   is_api_endpoint_subnet_public                                               = (var.cluster_endpoint_visibility == "Private") ? false : true
#   api_endpoint_subnet_id                                                      = oci_core_subnet.oke_k8s_endpoint_subnet[0].id
#   is_lb_subnet_public                                                         = true
#   lb_subnet_id                                                                = oci_core_subnet.oke_lb_subnet[0].id
#   is_nodepool_subnet_public                                                   = false
#   nodepool_subnet_id                                                          = oci_core_subnet.oke_nodes_subnet[0].id
#   ssh_public_key                                                              = var.ssh_public_key == "" ? tls_private_key.public_private_key_pair.public_key_openssh : var.ssh_public_key
#   availability_domain                                                         = data.oci_identity_availability_domains.ads.availability_domains[0]["name"]
#   # defined_tags                                                                = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
# }

resource "oci_containerengine_cluster" "oci_oke_cluster" {
  compartment_id     = var.compartment_ocid
  kubernetes_version = (var.k8s_version == "Latest") ? local.cluster_k8s_latest_version : var.k8s_version
  name               = "oke-cluster${local.resource_name_suffix}"  # var.oke_cluster_name
  vcn_id             = oci_core_virtual_network.oke_vcn[0].id      # var.use_existing_vcn ? var.vcn_id : oci_core_vcn.oke_vcn[0].id

  dynamic "endpoint_config" {
    for_each = var.vcn_native ? [1] : []
    content {
      is_public_ip_enabled = (var.cluster_endpoint_visibility == "Private") ? false : true  # var.is_api_endpoint_subnet_public
      subnet_id            = oci_core_subnet.oke_k8s_endpoint_subnet[0].id  # var.use_existing_vcn ? var.api_endpoint_subnet_id : oci_core_subnet.oke_api_endpoint_subnet[0].id
    }
  }

  options {
    service_lb_subnet_ids = [oci_core_subnet.oke_lb_subnet[0].id] # [var.use_existing_vcn ? var.lb_subnet_id : oci_core_subnet.oke_lb_subnet[0].id]

    add_ons {
      is_kubernetes_dashboard_enabled = var.cluster_options_add_ons_is_kubernetes_dashboard_enabled
      is_tiller_enabled               = false # var.cluster_options_add_ons_is_tiller_enabled
    }

    admission_controller_options {
      is_pod_security_policy_enabled = var.cluster_options_admission_controller_options_is_pod_security_policy_enabled
    }

    kubernetes_network_config {
      pods_cidr     = lookup(var.network_cidrs, "PODS-CIDR")                 # var.pods_cidr
      services_cidr = lookup(var.network_cidrs, "KUBERNETES-SERVICE-CIDR")   # var.services_cidr
    }
  }
  # defined_tags = var.defined_tags
}

resource "oci_containerengine_node_pool" "oci_oke_node_pool" {
  cluster_id         = oci_containerengine_cluster.oci_oke_cluster.id
  compartment_id     = var.compartment_ocid
  kubernetes_version = (var.k8s_version == "Latest") ? local.cluster_k8s_latest_version : var.k8s_version
  name               = var.node_pool_name
  node_shape         = var.node_pool_shape

  # initial_node_labels {
  #   key   = var.node_pool_initial_node_labels_key
  #   value = var.node_pool_initial_node_labels_value
  # }

  node_source_details {
    # image_id                = var.node_image_id == "" ? element([for source in data.oci_containerengine_node_pool_option.oci_oke_node_pool_option.sources : source.image_id if length(regexall("Oracle-Linux-${var.node_linux_version}-20[0-9]*.*", source.source_name)) > 0], 0) : var.node_image_id
    image_id                = element([for source in data.oci_containerengine_node_pool_option.oke.sources : source.image_id if length(regexall("Oracle-Linux-${var.node_pool_image_operating_system_version}-20[0-9]*.*", source.source_name)) > 0], 0)
    source_type             = "IMAGE"
    boot_volume_size_in_gbs = var.node_pool_boot_volume_size_in_gbs
  }

  ssh_public_key = var.ssh_public_key != "" ? var.ssh_public_key : tls_private_key.public_private_key_pair.public_key_openssh

  node_config_details {
    placement_configs {
      # availability_domain = var.availability_domain == "" ? data.oci_identity_availability_domains.ADs.availability_domains[0]["name"] : var.availability_domain
      # subnet_id           = var.use_existing_vcn ? var.nodepool_subnet_id : oci_core_subnet.oke_nodepool_subnet[0].id
      availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0]["name"]
      subnet_id           = oci_core_subnet.oke_nodes_subnet[0].id
    }
    size = var.node_pool_workers     # var.node_count
    # defined_tags = var.defined_tags
  }

  dynamic "node_shape_config" {
    for_each = length(regexall("Flex", var.node_pool_shape)) > 0 ? [1] : []
    content {
      ocpus         = var.node_pool_node_shape_config_ocpus          # var.node_ocpus
      memory_in_gbs = var.node_pool_node_shape_config_memory_in_gbs  # var.node_memory
    }
  }
  # defined_tags = var.defined_tags
}

# resource "oci_identity_compartment" "oke_compartment" {
#   compartment_id = var.compartment_id
#   name           = "${local.app_name_normalized}-${random_string.deploy_id.result}"
#   description    = "${var.app_name} ${var.oke_compartment_description} (Deployment ${random_string.deploy_id.result})"
#   enable_delete  = true
#
#   count = var.create_new_compartment_for_oke ? 1 : 0
# }
# locals {
#   oke_compartment_id = var.compartment_id
# }

# Local kubeconfig for when using Terraform locally. Not used by Oracle Resource Manager
resource "local_file" "kubeconfig" {
  content  = data.oci_containerengine_cluster_kube_config.oke_cluster_kube_config.content
  filename = "generated/kubeconfig"
}

# # Generate ssh keys to access Worker Nodes, if generate_public_ssh_key=true, applies to the pool
# resource "tls_private_key" "oke_worker_node_ssh_key" {
#   algorithm = "RSA"
#   rsa_bits  = 2048
# }

# Get OKE options
locals {
  cluster_k8s_latest_version   = reverse(sort(data.oci_containerengine_cluster_option.oke.kubernetes_versions))[0]
  node_pool_k8s_latest_version = reverse(sort(data.oci_containerengine_node_pool_option.oke.kubernetes_versions))[0]
}

# # Checks if is using Flexible Compute Shapes
# locals {
#   is_flexible_node_shape = contains(local.compute_flexible_shapes, var.node_pool_shape)
# }
