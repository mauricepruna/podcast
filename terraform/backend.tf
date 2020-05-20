# terraform {
#   backend "remote" {
#     hostname = "app.terraform.io"
#     organization = "esnoei"

#     workspaces {
#       name = "somosmas"
#     }
#   }
# }

terraform {
  backend "local" {
    path = "terraform/.terraform/terraform.tfstate"
  }
}