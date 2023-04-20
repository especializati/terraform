terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

provider "google" {
  credentials = file("gcp.json")

  project = "terraform-382820"
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_compute_instance" "app_example" {
  count = 2
  name = "terraform${count.index + 1}"
  machine_type = "e2-micro"
  zone = "us-central1-c"

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    network = "default"
    access_config {
      
    }
  }

  tags = ["${var.tag}${count.index + 1}", "http-server"]

  metadata = {
    ssh-keys = "${var.username}:${file("../ssh/terraform.pub")}"
  }

  depends_on = [
    google_storage_bucket.bucket-x
  ]

  metadata_startup_script = "${file("./script.sh")}"

  # connection {
  #   type = "ssh"
  #   user = var.username
  #   private_key = file("../ssh/terraform")
  #   host = self.network_interface[0].access_config[0].nat_ip
  # }

  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo apt-get update",
  #     "sudo apt-get install -y nginx",
  #     "sudo service nginx start"
  #   ]
  # }
}
