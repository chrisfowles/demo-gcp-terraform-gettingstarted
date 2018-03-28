### BIG GOTCHA: This is expensive stuff - it's easy to ring up a couple of hundred in a weekend - BE WARNED

resource "google_spanner_instance" "main" {
  # GOTCHA: You need to make sure your api (services) are enabled before you can deploy resources
  depends_on = [
    "google_project_services.project",
  ]

  project      = "${google_project.project.id}"
  config       = "nam-eur-asia1"
  display_name = "${var.project_name}"
  name         = "${google_project.project.id}"
  num_nodes    = 1
}

resource "google_spanner_database" "db" {
  # GOTCHA: You need to make sure your api (services) are enabled before you can deploy resources
  depends_on = [
    "google_project_services.project",
  ]

  project  = "${google_project.project.id}"
  instance = "${google_spanner_instance.main.name}"
  name     = "vault-database"

  ddl = [
    "CREATE TABLE Vault (Key STRING(MAX) NOT NULL, Value BYTES(MAX)) PRIMARY KEY (Key)",
  ]
}
