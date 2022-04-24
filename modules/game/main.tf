terraform {
  required_version = ">= 1.1.8"
}

provider "google" {
  project = var.project_name
  region  = var.region
}

module "server" {
  source = "./server"
  name = var.name
  docker_run_command = var.docker_run_command
  network_port = var.network_port
  network_protocol = var.network_protocol
}

module "start" {
  source = "./start"
  name = var.name
  server = module.server.server
  artifact_bucket = var.artifact_bucket
}

module "stop" {
  source = "./stop"
  name = var.name
  server = module.server.server
  artifact_bucket = var.artifact_bucket
}

module "status" {
  source = "./status"
  name = var.name
  server = module.server.server
  artifact_bucket = var.artifact_bucket
}
