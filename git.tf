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
  token = "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"
}



resource "github_repository" "Terraform_v12" {
  name        = "Terraform_v12"
  description = "My awesome codebase"

  visibility = "public"

}

