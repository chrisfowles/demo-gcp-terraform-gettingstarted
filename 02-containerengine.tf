resource "google_container_cluster" "primary" {
  project = "${google_project.project.id}"
  name    = "vibrato-demo-cluster"

  zone = "us-central1-a"

  additional_zones = [
    "us-central1-b",
    "us-central1-c",
  ]

  # GOTCHA: You need to make sure your api (services) are enabled before you can deploy resources
  depends_on = [
    "google_project_services.project",
  ]

  # GOTCHA: number of nodes to create PER ZONE:
  # i.e. this config is 3 nodes:
  # 1 x us-central1-a
  # 1 x us-central1-b
  # 1 x us-central1-c
  initial_node_count = 1

  node_config {
    machine_type = "n1-standard-1"

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}
