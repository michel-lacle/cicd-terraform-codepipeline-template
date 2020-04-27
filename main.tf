module "cicd-pipeline" {
  source = "./cicd-pipeline"

  application-name = "terraform-codepipeline-template"
  branch = "master"
  repository-name = aws_codecommit_repository.codecommit-repository.repository_name
}