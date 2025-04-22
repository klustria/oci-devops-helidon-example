## Copyright (c) 2023, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

locals {
  resource_name_suffix        = "-helidon_oci_guide"
  resource_name_random_suffix = "${local.resource_name_suffix}-${random_string.random_value.result}"
}

#random id generation
resource "random_string" "random_value" {
  length  = 4
  special = false
}
