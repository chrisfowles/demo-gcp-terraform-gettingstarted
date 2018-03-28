output "get_creds_command" {
  "value" = "gcloud container clusters get-credentials ${google_container_cluster.primary.name} --zone=${google_container_cluster.primary.zone}"
}
