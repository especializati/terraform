output "instances_ips" {
  # value = google_compute_instance.app_example[0].network_interface[0].access_config[0].nat_ip
  value = [for instance in google_compute_instance.app_example : instance.network_interface[0].access_config[0].nat_ip]
}