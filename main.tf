terraform {
  required_version = ">= 1.1.8"
  backend "gcs" {
    bucket = "game-management-348123-tf-state"
    prefix = "terraform/state"
  }
}

variable "project_name" {
  default = "game-management-348123"
}

variable "region" {
  default = "us-west1"
}

provider "google" {
  project = var.project_name
  region  = var.region
}

resource "google_storage_bucket" "artifact_bucket" {
  name = "${var.project_name}-code-bucket"
  location = var.region
}


module "Minecraft" {
  source = "./modules/game"
  name = "minecraft"
  docker_run_command = "docker run -d -p 25565:25565 -e EULA=TRUE -e VERSION=1.18.2 -e MEMORY=3G -v /var/minecraft:/data --name mc --rm=true itzg/minecraft-server:latest;"
  network_port = "25565"
  network_protocol = "tcp"
  artifact_bucket = google_storage_bucket.artifact_bucket
}

module "Info" {
  source = "./modules/info"
  artifact_bucket = google_storage_bucket.artifact_bucket
  games = [module.Minecraft]
}