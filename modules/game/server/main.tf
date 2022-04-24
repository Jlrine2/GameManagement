# based on minecraft terraform provided by https://github.com/futurice/terraform-examples/blob/1a8a081ca33973e1d9c3cf288a1b9818ca6e745c/google_cloud/minecraft/main.tf
terraform {
  required_version = ">= 1.1.8"
}

provider "google" {
  project = var.project_name
  region  = var.region
}

resource "google_compute_disk" "game-disk" {
  name  = "${var.name}-disk"
  type  = "pd-ssd"
  size  = 35
  zone  = "${var.region}-a"
  image = "cos-cloud/cos-stable"
}

resource "google_compute_address" "game-ip" {
  name = "${var.name}-ip"
  region = var.region
}

resource "google_compute_instance" "game-server" {
  name = "${var.name}-server"
  machine_type = "n2d-standard-2"
  zone = "${var.region}-a"
  tags = [var.name]
  metadata_startup_script = var.docker_run_command
  
  metadata = {
    enable-oslogin = "TRUE"
  }

  boot_disk {
    auto_delete = false # Keep disk after shutdown (game data)
    source      = google_compute_disk.game-disk.self_link
  }

  network_interface {
    network = google_compute_network.game-network.name
    access_config {
      nat_ip = google_compute_address.game-ip.address
    }
  }
}

resource "google_compute_network" "game-network" {
  name = "${var.name}"
}

resource "google_compute_firewall" "game-firewall" {
  name    = "${var.name}"
  network = google_compute_network.game-network.name

  allow {
    protocol = var.network_protocol
    ports    = [var.network_port, "22"]
  }
  # ICMP (ping)
  allow {
    protocol = "icmp"
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["${var.name}"]
}