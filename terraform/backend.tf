terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "esnoei"

    workspaces {
      name = "somosmas"
    }
  }
}