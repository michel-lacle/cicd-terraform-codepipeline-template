variable "application-name" {
  type = string
  default = "terraform-codepipeline-template"
}

module "pipeline-master" {
  source = "./cicd-pipeline"

  application-name = var.application-name
  branch = "master"
  repository-name = aws_codecommit_repository.codecommit-repository.repository_name
}

module "pipeline-master-succeeded-notifications" {
  source = "./cicd-notifications"

  codepipeline-name = module.pipeline-master.codepipeline-name
  s3-bucket-name = module.pipeline-master.cicd-artifact-bucket-name
  slack-url = var.slack-url-succeeded
}

module "pipeline-dev" {
  source = "./cicd-pipeline"

  application-name = var.application-name
  branch = "dev"
  repository-name = aws_codecommit_repository.codecommit-repository.repository_name
}