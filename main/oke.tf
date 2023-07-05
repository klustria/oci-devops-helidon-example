## Copyright (c) 2021, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

module "oke-deployment" {
  count                    = var.use_oke_cluster ? 1 : 0
  source                   = "./oke"
  # availability_domains = data.oci_identity_availability_domains.ads.availability_domains
  region                   = var.region
  tenancy_namespace        = data.oci_objectstorage_namespace.object_storage_namespace.id
  availability_domain_name = var.availablity_domain_name == "" ? data.oci_identity_availability_domains.ads.availability_domains[0]["name"] : var.availablity_domain_name
  compartment_ocid         = var.compartment_ocid
  artifact_repository_id   = oci_artifacts_repository.artifact_repo.id
  devops_project_id        = oci_devops_project.devops_project.id
  devops_repo_name         = oci_devops_repository.devops_repo.name
  devops_repo_id           = oci_devops_repository.devops_repo.id
  devops_repo_http_url     = oci_devops_repository.devops_repo.http_url
  k8s_version              = "Latest"
  node_pool_workers        = 1
  resource_name_suffix     = local.resource_name_suffix
  ssh_public_key           = var.ssh_public_key == "" ? tls_private_key.public_private_key_pair.public_key_openssh : var.ssh_public_key
}
