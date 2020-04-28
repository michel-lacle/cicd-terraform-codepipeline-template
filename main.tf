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


module "cicd-pipeline-master-build-succeeded-notification" {
  source = "./cicd-notification"

  codepipeline-name = module.cicd-pipeline-master-branch.codepipeline-name
  s3-bucket-name = module.cicd-pipeline-master-branch.cicd-artifact-bucket-name
  slack-url = var.slack-url-succeeded

  message =<<EOT
  Build Succeeded, please download latest artifact here:
https://s3.console.aws.amazon.com/s3/buckets/${module.cicd-pipeline-dev-branch.cicd-artifact-bucket-name}/?region=us-east-1
EOT
  subject = "New Build Available"
}



module "cicd-pipeline-dev-branch" {
  source = "./cicd-pipeline"

  application-name = var.application-name
  branch = "dev"
  repository-name = aws_codecommit_repository.codecommit-repository.repository_name
}
