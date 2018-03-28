resource "google_sql_database_instance" "db_instance" {
  # GOTCHA: You need to make sure your api (services) are enabled before you can deploy resources
  depends_on = [
    "google_project_services.project",
  ]

  project = "${google_project.project.id}"
  name    = "vibrato-postgres"

  # Postgres Support is in BETA
  database_version = "POSTGRES_9_6"
  region           = "us-central1"

  settings {
    # Second-generation instance tiers are based on the machine type.
    tier = "db-f1-micro"
  }
}

resource "google_sql_database" "users-db" {
  # GOTCHA: You need to make sure your api (services) are enabled before you can deploy resources
  depends_on = [
    "google_project_services.project",
  ]

  project   = "${google_project.project.id}"
  name      = "users-db"
  instance  = "${google_sql_database_instance.db_instance.name}"
  charset   = "UTF8"
  collation = "en_US.UTF8"
}

resource "google_sql_user" "users" {
  # GOTCHA: You need to make sure your api (services) are enabled before you can deploy resources
  depends_on = [
    "google_project_services.project",
  ]

  project  = "${google_project.project.id}"
  name     = "db_user"
  instance = "${google_sql_database_instance.db_instance.name}"
  password = "${var.db_password}"
}
