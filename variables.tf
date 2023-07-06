## Copyright (c) 2023, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

variable "tenancy_ocid" {}
variable "compartment_ocid" {
  default = ""
}
variable "ssh_public_key" {
  default = ""
}
variable "availablity_domain_name" {
  default = ""
}
variable "home_region" {
  default = ""
}
variable "region" {
  default = ""
}

# Best to set values for below variables in terraform.tfvars under the following conditions:
# 1. If using user principal authentication.
# 2. If user needs additional policy to access the created compartment and add cloud shell, which in this
#    scenario, needs only "user_ocid" to be set up.
variable "user_ocid" {
  default = ""
}
variable "fingerprint" {
  default = ""
}

variable "project_logging_config_retention_period_in_days" {
  default = 30
}

variable "project_description" {
  default = "DevOps Project for Instance Group deployment of a Helidon Application"
}

variable "use_oke_cluster" {
  default     = true
  description = "Creates a new OKE cluster, node pool and network resources"
}

variable "deployment_target" {
  type    = string
  default = "ALL"
  validation {
    condition     = contains(["OKE", "INSTANCE", "ALL"], upper(var.deployment_target))
    error_message = "Must be either \"OKE\", \"INSTANCE\" or \"ALL\"."
  }
}
