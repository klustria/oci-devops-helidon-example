## Copyright (c) 2023, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

variable "resource_name_suffix" {
  default = ""
}

#
variable "devops_project_id" {
  default = ""
}

variable "artifact_repository_id" {
  default = ""
}

variable "devops_repo_name" {
  default = ""
}

variable "devops_repo_id" {
  default = ""
}

variable "devops_repo_http_url" {
  default = ""
}
#

variable "compartment_ocid" {
  default = ""
}

variable "private_key_path" {
  default = ""
}

# Allows provisioned compute instance to be ssh'd with corresponding private key. If empty, a public/private ssh key pair
# will be generated and private key can be extracted from the TF state.
variable "ssh_public_key" {
  default = ""
}

variable "availablity_domain_name" {
  default = ""
}
variable "VCN-CIDR" {
  default = "10.0.0.0/16"
}

variable "Subnet-CIDR" {
  default = "10.0.0.0/24"
}

variable "instance_shape" {
  description = "Instance Shape"
  default     = "VM.Standard.E4.Flex"
}

variable "instance_ocpus" {
  default = 1
}

variable "instance_shape_config_memory_in_gbs" {
  default = 16
}

variable "instance_os" {
  description = "Operating system for compute instances"
  default     = "Oracle Linux"
}

variable "linux_os_version" {
  description = "Operating system version for all Linux instances"
  default     = "8"
}
