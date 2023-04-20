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

variable "image" {
  type = string
  default = "debian-cloud/debian-10"
}

variable "tag" {
  type = string
  default = "terraform"
}

variable "username" {
  type = string
  default = "carlos"
}

resource "google_compute_instance" "app_example" {
  count = 1
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

  tags = ["${var.tag}${count.index + 1}"]

  metadata = {
    ssh-keys = "${var.username}:${file("../ssh/terraform.pub")}"
  }

  depends_on = [
    google_storage_bucket.bucket-x
  ]
}

resource "google_storage_bucket" "bucket-x" {
  name = "eti-bucket-project-x"
  location = "US"
  storage_class = "STANDARD"
}

resource "google_storage_bucket_object" "example_object" {
  name = "example.log"
  bucket = google_storage_bucket.bucket-x.name
  source = "./test.log"
}
