resource "google_runtimeconfig_config" "connection-string" {
  # GOTCHA: You need to make sure your api (services) are enabled before you can deploy resources
  depends_on = [
    "google_project_services.project",
  ]

  project     = "${google_project.project.id}"
  name        = "connection-string"
  description = "Connection string for connecting to my database."
}

resource "google_runtimeconfig_variable" "my-secret" {
  # GOTCHA: You need to make sure your api (services) are enabled before you can deploy resources
  depends_on = [
    "google_project_services.project",
  ]

  project = "${google_project.project.id}"
  parent  = "${google_runtimeconfig_config.connection-string.name}"
  name    = "secret"
  value   = "SomeSecretValueFromSomewhere"
}
