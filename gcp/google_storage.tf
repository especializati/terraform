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