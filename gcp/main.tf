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
  count = 3
  name = "terraform${count.index + 1}"
  machine_type = "e2-micro"
  zone = "us-central1-c"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    network = "default"
    access_config {
      
    }
  }

  tags = ["terraform${count.index + 1}"]

  metadata = {
    ssh-keys = "carlos:${file("../ssh/terraform.pub")}"
  }
}

resource "google_storage_bucket" "bucket" {
  name = "eti-bucket-project-x"
  location = "US"
  storage_class = "STANDARD"
}
