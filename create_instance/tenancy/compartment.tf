## Copyright (c) 2023, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_identity_compartment" "compartment" {
  name           = "compartment${var.resource_name_suffix}"
  description    = "Helidon OCI Guide demo compartment"
  compartment_id = var.tenancy_ocid
  enable_delete  = true
}

