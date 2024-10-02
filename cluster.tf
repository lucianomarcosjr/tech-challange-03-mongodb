terraform {
  required_providers {
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "1.12.0"
    }
  }
}

resource "mongodbatlas_project" "project" {
  name   = var.project_name
  org_id = var.org_id
}

resource "mongodbatlas_cluster" "cluster" {
  project_id                   = mongodbatlas_project.project.id
  name                         = "ClusterFastAPIM0"
  cluster_type                 = "REPLICASET"
  provider_name                = "TENANT"
  provider_instance_size_name  = "M0"
  provider_region_name         = "US_EAST_1"
  backing_provider_name        = "AWS"
  auto_scaling_disk_gb_enabled = true
}
