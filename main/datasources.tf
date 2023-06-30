## Copyright (c) 2023, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

# Get list of availability domains
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

# Get object storage namespace
data "oci_objectstorage_namespace" "object_storage_namespace" {
  #Optional
  compartment_id = var.compartment_ocid
}
