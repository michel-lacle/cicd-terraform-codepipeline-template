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

data "template_file" "build-succeeded-event-rulefile" {
  template = file("pipeline-event-rule.tpl")

  vars = {
    codepipeline-name = module.cicd-pipeline-master-branch.codepipeline-name
    event = "SUCCEEDED"
  }
}


module "cicd-pipeline-master-build-succeeded-notification" {
  source = "./cicd-notification"

  name = "build-succeeded"
  codepipeline-name = module.cicd-pipeline-master-branch.codepipeline-name
  slack-url = var.slack-url-succeeded

  message =<<EOT
  Build Succeeded, please download latest artifact here: https://s3.console.aws.amazon.com/s3/buckets/${module.cicd-pipeline-master-branch.cicd-artifact-bucket-name}/?region=us-east-1
EOT
  subject = "New Build Available"

  state = "SUCCEEDED"

  rule = data.template_file.build-succeeded-event-rulefile.rendered
}

module "cicd-pipeline-master-build-failed-notification" {
  source = "./cicd-notification"

  name = "build-failed"
  codepipeline-name = module.cicd-pipeline-master-branch.codepipeline-name
  slack-url = var.slack-url-failed

  message =<<EOT
  Build Failed, please check the build output here:
https://console.aws.amazon.com/codesuite/codepipeline/pipelines/${module.cicd-pipeline-master-branch.codepipeline-name}/view?region=us-east-1#
EOT

  subject = "Build Failed"
  state = "FAILED"
}

module "cicd-pipeline-dev-branch" {
  source = "./cicd-pipeline"

  application-name = var.application-name
  branch = "dev"
  repository-name = aws_codecommit_repository.codecommit-repository.repository_name
}

module "cicd-pipeline-dev-build-succeeded-notification" {
  source = "./cicd-notification"

  name = "build-succeeded"
  codepipeline-name = module.cicd-pipeline-dev-branch.codepipeline-name
  slack-url = var.slack-url-succeeded

  message =<<EOT
  Build Succeeded, please download latest artifact here: https://s3.console.aws.amazon.com/s3/buckets/${module.cicd-pipeline-dev-branch.cicd-artifact-bucket-name}/?region=us-east-1
EOT
  subject = "New Build Available"

  state = "SUCCEEDED"
}

module "cicd-pipeline-dev-build-failed-notification" {
  source = "./cicd-notification"

  name = "build-failed"
  codepipeline-name = module.cicd-pipeline-dev-branch.codepipeline-name
  slack-url = var.slack-url-failed

  message =<<EOT
  Build Failed, please check the build output here: https://console.aws.amazon.com/codesuite/codepipeline/pipelines/${module.cicd-pipeline-dev-branch.codepipeline-name}/view?region=us-east-1#
EOT

  subject = "Build Failed"
  state = "FAILED"
}
