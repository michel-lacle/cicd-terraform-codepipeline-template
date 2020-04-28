variable "application-name" {
  type = string
  default = "terraform-codepipeline-template"
}

module "cicd-pipeline-master-branch" {
  source = "./cicd-pipeline"

  application-name = var.application-name
  branch = "master"
  repository-name = aws_codecommit_repository.codecommit-repository.repository_name
}

module "cicd-pipeline-master-branch-notifications" {
  source = "./cicd-notifications"

  codepipeline-name = module.cicd-pipeline-master-branch.codepipeline-name
  s3-bucket-name = module.cicd-pipeline-master-branch.cicd-artifact-bucket-name
  slack-url = var.slack-url-succeeded
}

module "cicd-pipeline-dev-branch" {
  source = "./cicd-pipeline"

  application-name = var.application-name
  branch = "dev"
  repository-name = aws_codecommit_repository.codecommit-repository.repository_name


}