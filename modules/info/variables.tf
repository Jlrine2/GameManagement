variable "project_name" {
  default = "game-management-348123"
}

variable "region" {
  default = "us-west1"
}

variable "artifact_bucket" {}

variable games {
  type = list
}
