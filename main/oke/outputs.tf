## Copyright (c) 2021, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl


output "dev" {
  value = "Made with \u2764 by Oracle Developers"
}

output "comments" {
  value = "The application URL will be unavailable for a few minutes after provisioning while the application is configured and deployed to Kubernetes"
}

# output "deploy_id" {
#   value = random_string.deploy_id.result
# }
#
# output "deployed_to_region" {
#   value = var.region
# }

output "deployed_oke_kubernetes_version" {
  value = (var.k8s_version == "Latest") ? local.cluster_k8s_latest_version : var.k8s_version
}

output "kubeconfig_for_kubectl" {
  value       = "export KUBECONFIG=./generated/kubeconfig"
  description = "If using Terraform locally, this command set KUBECONFIG environment variable to run kubectl locally"
}
