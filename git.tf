terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

# Configure the GitHub Provider
provider "github" {
  token = var.git_token
}



resource "github_repository" "Terraform_v12" {
  name        = "Terraform_v12"
  description = "My awesome codebase"

  visibility = "public"

}

