## Copyright (c) 2023, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

# Create OCI Notification
resource "oci_ons_notification_topic" "devops_notification_topic" {
  compartment_id = var.compartment_ocid
  name           = "devops-topic${local.resource_name_random_suffix}"
}

# Create devops project
resource "oci_devops_project" "devops_project" {
  compartment_id = var.compartment_ocid
  name           = "devops-project${local.resource_name_random_suffix}"
  notification_config {
    topic_id = oci_ons_notification_topic.devops_notification_topic.id
  }
  description = var.project_description
}

# Create OCI Code Repository
resource "oci_devops_repository" "devops_repo" {
  name            = local.application_repo_name
  description     = "Will host Helidon OCI MP template app generated via the archetype tool"
  project_id      = oci_devops_project.devops_project.id
  repository_type = "HOSTED"
  default_branch  = "main"
}

#### Start of deploy artifacts code which will be used by the Upload Artifact Stage and the Deploy Instance Group Stage #####

# Create deployment spec artifact to use. The deployment spec will be renamed to "deployment_manifest.yaml"
# when uploaded to Artifact Repository.
resource "oci_devops_deploy_artifact" "devops_deployment_spec_artifact" {
  argument_substitution_mode = "SUBSTITUTE_PLACEHOLDERS"
  deploy_artifact_type       = "DEPLOYMENT_SPEC"
  project_id                 = oci_devops_project.devops_project.id
  display_name               = "devops-deployment-spec-artifact${local.resource_name_suffix}"
  deploy_artifact_source {
    deploy_artifact_path        = "deployment_manifest.yaml"
    deploy_artifact_source_type = "GENERIC_ARTIFACT"
    deploy_artifact_version     = "$${BUILDRUN_HASH}"
    repository_id               = oci_artifacts_repository.artifact_repo.id
  }
}

# Create application artifact to use. The generic file which will correspond to the Helidon App
# will be renamed to "helidon-oci-mp.tgz" when uploaded to Artifact Repository.
resource "oci_devops_deploy_artifact" "devops_application_artifact" {
  argument_substitution_mode = "SUBSTITUTE_PLACEHOLDERS"
  deploy_artifact_type       = "GENERIC_FILE"
  project_id                 = oci_devops_project.devops_project.id
  display_name               = "devops-application-artifact${local.resource_name_suffix}"
  deploy_artifact_source {
    deploy_artifact_path        = "helidon-oci-mp.tgz"
    deploy_artifact_source_type = "GENERIC_ARTIFACT"
    deploy_artifact_version     = "$${BUILDRUN_HASH}"
    repository_id               = oci_artifacts_repository.artifact_repo.id
  }
}

#### End of deploy artifacts code #####


# Create log group that will serve as the logical container for the devops log
resource "oci_logging_log_group" "devops_log_group" {
  compartment_id = var.compartment_ocid
  display_name   = "devops-log-group${local.resource_name_suffix}"
}

# Create log to store devops logging
resource "oci_logging_log" "devops_log" {
  display_name = "devops-log${local.resource_name_suffix}"
  log_group_id = oci_logging_log_group.devops_log_group.id
  log_type     = "SERVICE"
  configuration {
    source {
      category    = "all"
      resource    = oci_devops_project.devops_project.id
      service     = "devops"
      source_type = "OCISERVICE"
    }
    compartment_id = var.compartment_ocid
  }
  is_enabled         = true
  retention_duration = var.project_logging_config_retention_period_in_days
}
