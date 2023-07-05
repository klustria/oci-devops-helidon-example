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
