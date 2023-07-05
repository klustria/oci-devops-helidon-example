## Copyright (c) 2021, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

module "instance-deployment" {
  count                   = length(regexall("(?i)^(INSTANCE|ALL)$", var.deployment_target)) > 0 ? 1 : 0
  source                  = "./instance"
  availablity_domain_name = var.availablity_domain_name == "" ? data.oci_identity_availability_domains.ads.availability_domains[0]["name"] : var.availablity_domain_name
  compartment_ocid        = var.compartment_ocid
  resource_name_suffix    = local.resource_name_suffix
  artifact_repository_id  = oci_artifacts_repository.artifact_repo.id
  devops_project_id       = oci_devops_project.devops_project.id
  devops_repo_name        = oci_devops_repository.devops_repo.name
  devops_repo_id          = oci_devops_repository.devops_repo.id
  devops_repo_http_url    = oci_devops_repository.devops_repo.http_url
}
