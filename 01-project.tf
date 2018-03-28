# -------------------------------------
# Data source for a billing account
# -------------------------------------
data "google_billing_account" "acct" {
  display_name = "${var.billing_account_name}"
  open         = true
}

# -------------------------------------
# Data source for a billing account
# -------------------------------------
data "google_organization" "org" {
  domain = "${var.org_domain}"
}

# -------------------------------------
# Folder to put our project in
# Gotcha: You need to ensure that you have Folder Admin permission on the org
# Org Admin isn't enough
# -------------------------------------
resource "google_folder" "demos" {
  display_name = "Demos"
  parent       = "${data.google_organization.org.name}"
}

# -------------------------------------
# Generate a random Project ID
# -------------------------------------
resource "random_pet" "project_id" {
  length    = "2"
  separator = "-"
}

# -------------------------------------
# A project to put our resources in
# -------------------------------------
resource "google_project" "project" {
  name       = "${var.project_name}"
  project_id = "${random_pet.project_id.id}"

  # GOTCHA: if you don't set this you will unlink billing from your project and things will break
  billing_account = "${data.google_billing_account.acct.id}"
}

# -------------------------------------
# Allow service APIs for project
# -------------------------------------
resource "google_project_services" "project" {
  # Gotcha: Missing this wont show up on a plan - but most resources will need it
  project = "${google_project.project.id}"

  services = [
    "runtimeconfig.googleapis.com",
    "containerregistry.googleapis.com",
    "pubsub.googleapis.com",
    "compute.googleapis.com",
    "deploymentmanager.googleapis.com",
    "replicapool.googleapis.com",
    "replicapoolupdater.googleapis.com",
    "resourceviews.googleapis.com",
    "stackdriver.googleapis.com",
    "logging.googleapis.com",
    "container.googleapis.com",
    "storage-api.googleapis.com",
    "spanner.googleapis.com",
    "monitoring.googleapis.com",
  ]
}
