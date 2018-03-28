resource "google_pubsub_topic" "logging" {
  # GOTCHA: You need to make sure your api (services) are enabled before you can deploy resources
  depends_on = [
    "google_project_services.project",
  ]

  project = "${google_project.project.id}"
  name    = "logging-topic"
}

resource "google_logging_project_sink" "my-sink" {
  # GOTCHA: You need to make sure your api (services) are enabled before you can deploy resources
  depends_on = [
    "google_project_services.project",
  ]

  project = "${google_project.project.id}"
  name    = "my-pubsub-instance-sink"

  destination = "pubsub.googleapis.com/projects/${google_project.project.id}/topics/${google_pubsub_topic.logging.name}"

  filter = ""

  unique_writer_identity = true
}

resource "google_pubsub_subscription" "default" {
  # GOTCHA: You need to make sure your api (services) are enabled before you can deploy resources
  depends_on = [
    "google_project_services.project",
  ]

  project = "${google_project.project.id}"
  name    = "sumologic"
  topic   = "projects/${google_project.project.id}/topics/${google_pubsub_topic.logging.name}"

  ack_deadline_seconds = 20

  # GOTCHA: You need to prove ownership of any HTTP endpoints that you're pushing to.
  # This is a complex and somewhat manual processes.
  push_config {
    push_endpoint = "${var.sumologic_collector}"
  }
}
