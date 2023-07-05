## Copyright (c) 2023, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl


##### Start of Build Pipeline Code #####

# Create build pipeline
resource "oci_devops_build_pipeline" "devops_build_pipeline_oke" {
  project_id   = var.devops_project_id
  display_name = "devops-build-pipeline-oke${var.resource_name_suffix}"
  description  = "Build Pipeline"
}

# 1st build pipeline stage - Managed Build
resource "oci_devops_build_pipeline_stage" "devops_build_oke_stage" {
  build_pipeline_id = oci_devops_build_pipeline.devops_build_pipeline_oke.id
  build_pipeline_stage_predecessor_collection {
    items {
      id = oci_devops_build_pipeline.devops_build_pipeline_oke.id
    }
  }
  display_name              = "devops-build-stage-oke${var.resource_name_suffix}"
  description               = "1st build pipeline stage - Managed Build"
  build_pipeline_stage_type = "BUILD"
  build_runner_shape_config {
    build_runner_type = "DEFAULT"
  }
  image                = "OL7_X86_64_STANDARD_10"
  build_spec_file      = "build_oke.yaml"
  primary_build_source = var.devops_repo_name
  build_source_collection {
    items {
      connection_type = "DEVOPS_CODE_REPOSITORY"
      repository_id   = var.devops_repo_id
      name            = var.devops_repo_name
      repository_url  = var.devops_repo_http_url
      branch          = "main"
    }
  }
  stage_execution_timeout_in_seconds = "36000"
}

# 2nd build pipeline stage - Upload Artifact
resource "oci_devops_build_pipeline_stage" "devops_upload_oke_stage" {
  build_pipeline_id = oci_devops_build_pipeline.devops_build_pipeline_oke.id
  build_pipeline_stage_predecessor_collection {
    items {
      id = oci_devops_build_pipeline_stage.devops_build_oke_stage.id
    }
  }
  display_name              = "devops-upload-oke-stage${var.resource_name_suffix}"
  description               = "2nd build pipeline stage - Upload Artifact"
  build_pipeline_stage_type = "DELIVER_ARTIFACT"
  deliver_artifact_collection {
    items {
      artifact_id   = oci_devops_deploy_artifact.devops_oke_application_docker_artifact.id
      artifact_name = "app_base_image"
    }
    items {
      artifact_id   = oci_devops_deploy_artifact.devops_oke_deployment_spec_artifact.id
      artifact_name = "deployment_kube_manifest"
    }
  }
}

# 3rd build pipeline stage - Trigger Deployment
resource "oci_devops_build_pipeline_stage" "devops_trigger_deployment_oke_stage" {
  build_pipeline_id = oci_devops_build_pipeline.devops_build_pipeline_oke.id
  build_pipeline_stage_predecessor_collection {
    items {
      id = oci_devops_build_pipeline_stage.devops_upload_oke_stage.id
    }
  }
  display_name                   = "devops-trigger-deployment-oke-stage${var.resource_name_suffix}"
  description                    = "3rd build pipeline stage - Trigger Deployment"
  build_pipeline_stage_type      = "TRIGGER_DEPLOYMENT_PIPELINE"
  deploy_pipeline_id             = oci_devops_deploy_pipeline.devops_deploy_pipeline_oke.id
  is_pass_all_parameters_enabled = true
}

##### End of Build Pipeline Code #####

##### Start of Deployment Pipeline Code #####

# Create deployment pipeline and pass in the Artifact Repository OCID as a parameter
resource "oci_devops_deploy_pipeline" "devops_deploy_pipeline_oke" {
  project_id   = var.devops_project_id
  description  = "Deploy Pipleline"
  display_name = "devops-deployment-pipeline-oke${var.resource_name_suffix}"
  deploy_pipeline_parameters {
    items {
      name          = "REGISTRY_ENDPOINT"
      description   = "Container image registry endpoint"
      default_value = "${var.region}.ocir.io"
    }
    items {
      name          = "TENANCY_NAMESPACE"
      description   = "Tenancy namespace that will be used to locate the image from the container registry"
      default_value = var.tenancy_namespace
    }
  }
}

# Create a deployment stage in the deployment pipeline targeting compute instance as the deployment destination
resource "oci_devops_deploy_stage" "devops_deploy_oke_stage" {
  deploy_pipeline_id = oci_devops_deploy_pipeline.devops_deploy_pipeline_oke.id
  deploy_stage_predecessor_collection {
    items {
      id = oci_devops_deploy_pipeline.devops_deploy_pipeline_oke.id
    }
  }
  deploy_stage_type                            = "OKE_DEPLOYMENT"
  display_name                                 = "devops-deployment-oke-stage${var.resource_name_suffix}"
  description                                  = "Deployment Pipeline Stage that will set an oke cluster as the target platform"
  oke_cluster_deploy_environment_id            = oci_devops_deploy_environment.devops_deploy_oke_environment.id
  kubernetes_manifest_deploy_artifact_ids      = [oci_devops_deploy_artifact.devops_oke_deployment_spec_artifact.id]
  rollback_policy {
    policy_type = "AUTOMATED_STAGE_ROLLBACK_POLICY"
  }
}

# Create environment to set compute instance as target platform for deployment pipeline
resource "oci_devops_deploy_environment" "devops_deploy_oke_environment" {
  project_id              = var.devops_project_id
  display_name            = "devops-oke-environment${var.resource_name_suffix}"
  description             = "Sets an OKE cluster as the target platform for deployment pipeline"
  deploy_environment_type = "OKE_CLUSTER"
  cluster_id              = oci_containerengine_cluster.oci_oke_cluster.id
}

##### End of Deployment Pipeline Code #####

#### Start of deploy artifacts code which will be used by the Upload Artifact Stage and the Deploy Instance Group Stage #####

# Create kubernetes deployment manifest.
resource "oci_devops_deploy_artifact" "devops_oke_deployment_spec_artifact" {
  argument_substitution_mode = "SUBSTITUTE_PLACEHOLDERS"
  deploy_artifact_type       = "KUBERNETES_MANIFEST"
  project_id                 = var.devops_project_id
  display_name               = "devops-oke-deployment-spec-artifact${var.resource_name_suffix}"
  deploy_artifact_source {
    deploy_artifact_path        = "oke_manifest.yaml"
    deploy_artifact_source_type = "GENERIC_ARTIFACT"
    deploy_artifact_version     = "$${BUILDRUN_HASH}"
    repository_id               = var.artifact_repository_id
  }
}

# Create Helidon application docker image.
resource "oci_devops_deploy_artifact" "devops_oke_application_docker_artifact" {
  argument_substitution_mode = "SUBSTITUTE_PLACEHOLDERS"
  deploy_artifact_type       = "DOCKER_IMAGE"
  project_id                 = var.devops_project_id
  display_name               = "devops-application-artifact${var.resource_name_suffix}"
  deploy_artifact_source {
    deploy_artifact_source_type = "OCIR"
    image_uri                   = "${var.region}.ocir.io/${var.tenancy_namespace}/oci-mp-server:$${BUILDRUN_HASH}"
  }
}

#### End of deploy artifacts code #####

# Create a trigger to start the pipeline if code repository push event occurs
resource "oci_devops_trigger" "devops_oke_trigger" {
  project_id     = var.devops_project_id
  display_name   = "devops-oke-trigger${var.resource_name_suffix}"
  description    = "Will trigger start of OKE pipeline when push event on the code repository takes place"
  trigger_source = "DEVOPS_CODE_REPOSITORY"
  repository_id  = var.artifact_repository_id
  actions {
    build_pipeline_id = oci_devops_build_pipeline.devops_build_pipeline_oke.id
    type              = "TRIGGER_BUILD_PIPELINE"
    filter {
      trigger_source = "DEVOPS_CODE_REPOSITORY"
      events         = ["PUSH"]
      include {
        head_ref = "main"
      }
    }
  }
}
