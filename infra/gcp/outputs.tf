output "cluster_name" {
    value = google_container_cluster.mlops_gke.name
}

output "location" {
    value = var.zone
}