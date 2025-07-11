terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.6.0"
}

provider "google" {
    project = var.project_id
    region = var.region
    zone = var.zone
    credentials = file("${path.module}/credentials.json")
}

resource "google_container_cluster" "mlops_gke" {
    name = "mlops-gke"
    location = var.zone

    remove_default_node_pool = true
    initial_node_count = 1

    network = "default"
    subnetwork = "default"

    deletion_protection = false
}

resource "google_container_node_pool" "primary_nodes" {
    name = "mlops-node-pool"
    cluster = google_container_cluster.mlops_gke.name
    location = var.zone

    node_config {
        preemptible = true
        machine_type = "e2-standard-2"
        oauth_scopes = [
            "https://www.googleapis.com/auth/cloud-platform"
        ]
    }

    initial_node_count = 2
}