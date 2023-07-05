## Copyright (c) 2023, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

// Helidon Application container repository
resource "oci_artifacts_container_repository" "container_repo" {
  compartment_id = var.compartment_ocid
  display_name = "oci-mp-server"

  is_public = true
}
