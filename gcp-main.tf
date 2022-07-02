
# Create Artifact Registry Repository for Docker containers
resource "google_artifact_registry_repository" "python-gcp-cloud" {
  provider = google-beta

  location = "us-central1"
  repository_id = "pythongcpcloud"
  description = "Imagens Docker python gco cloud"
  format = "DOCKER"
  # depends_on = [time_sleep.wait_30_seconds]
}

# Deploy image to Cloud Run
resource "google_cloud_run_service" "python-gcp-cloud" {
  count = 1
  name = "python-gcp-cloud"
  location = "us-central1"

  metadata {
    annotations = {
      "run.googleapis.com/client-name" = "terraform",
      "autoscaling.knative.dev/minScale" = "0"
      "autoscaling.knative.dev/maxScale" = "1"
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  template {
    spec {
      containers {
        image = "us-docker.pkg.dev/cloudrun/container/hello"
      }
    }
  }

  depends_on = [google_artifact_registry_repository.python-gcp-cloud]
}

# Allow unauthenticated users to invoke the service
resource "google_cloud_run_service_iam_member" "run_all_users" {
  service  = google_cloud_run_service.python-gcp-cloud.name
  location = google_cloud_run_service.python-gcp-cloud.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

output "cloud_run_instance_url" {
  value = google_cloud_run_service.python-gcp-cloud.status[0].url
}

resource "google_sql_database_instance" "instance" {
    name = "mysql-db-instance"
    database_version = "MYSQL_8_0"
    region = "us-central1"
    settings {
        tier = "db-f1-micro"
    }
}

resource "google_sql_database" "database" {
    name = "pytask"
    instance = "${google_sql_database_instance.instance.name}"
    charset = "utf8"
    collation = "utf8_general_ci"
}

resource "google_sql_user" "users" {
    name = "root"
    instance = "${google_sql_database_instance.instance.name}"
    host = "%"
    password = "mysqlpass"
}