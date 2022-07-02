# Enable Artifact Registry API
# resource "google_project_service" "artifactregistry" {
#   provider = google-beta
#   service = "artifactregistry.googleapis.com"
#   disable_on_destroy = false
# }

# # Enable Cloud Run API
# resource "google_project_service" "cloudrun" {
#  project = "rds-labdevopscloud"
#  service = "run.googleapis.com"
#  disable_on_destroy = false
# }

# # Enable Cloud Resource Manager API
# resource "google_project_service" "resourcemanager" {
#   project = "rds-labdevopscloud"
#   service  = "cloudresourcemanager.googleapis.com"
#   disable_on_destroy = false
# }

# Service Networking API

# resource "time_sleep" "wait_30_seconds" {
#   create_duration = "60s"
#   depends_on = [
#     google_project_service.artifactregistry,
#     google_project_service.cloudrun,
#     google_project_service.resourcemanager
#     ]
# }