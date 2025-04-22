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

variable "instance_shape" {
  default = ""
}

variable "instance_ocpus" {
  default = ""
}

variable "instance_shape_config_memory_in_gbs" {
  default = ""
}

variable "instance_os" {
  default = ""
}

variable "instance_os_version" {
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

