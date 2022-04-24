terraform {
  required_version = ">= 1.1.8"
}

provider "google" {
  project = var.project_name
  region  = var.region
}

data "archive_file" "api_code" {
  type        = "zip"
  source_dir  = "${path.module}/src"
  output_path = ".dist/${var.name}-start.zip"
}

resource "google_storage_bucket_object" "code_archive" {
  name   = "${var.name}_start_${data.archive_file.api_code.output_md5}.zip"
  bucket = var.artifact_bucket.name
  source = data.archive_file.api_code.output_path
}

resource "google_cloudfunctions_function" "function" {
  depends_on = [
    data.archive_file.api_code
  ]
  name         = "${var.name}_start"
  entry_point  = "start_server"
  description  = "function for ${var.name} start"
  runtime      = "python39"
  timeout      = 300
  trigger_http = true

  environment_variables = {
    "SERVER" = var.server.name,
    "PROJECT_ID": var.project_name,
    "REGION": var.region
  }

  source_archive_bucket = var.artifact_bucket.name
  source_archive_object = google_storage_bucket_object.code_archive.name
}

resource "google_cloudfunctions_function_iam_binding" "function_iam_binding" {
  project        = var.project_name
  region         = var.region
  cloud_function = google_cloudfunctions_function.function.name
  role           = "roles/cloudfunctions.invoker"
  members = [
    "allUsers"
  ]
}


