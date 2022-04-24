output "server" {
  value = google_compute_instance.game-server
}

output "ip-addr" {
  value = google_compute_address.game-ip.address
}

output "firewall" {
  value = google_compute_firewall.game-firewall
}