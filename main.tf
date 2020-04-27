variable "application-name" {
  type = string
  default = "terraform-codepipeline-template"
}

variable "branch-name" {
  type = string
  default = "master"
}


module "cicd-pipeline" {
  source = "./cicd-pipeline"

  application-name = var.application-name
  branch = var.branch-name
  repository-name = aws_codecommit_repository.codecommit-repository.repository_name
}