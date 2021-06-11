terraform {
  backend "gcs" {
    bucket  = "tf-state-rafayel-sahakyan-tet"
    prefix  = "terraform/state"
  }
}
