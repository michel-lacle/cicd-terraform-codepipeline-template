# the repo of our application
resource "aws_codecommit_repository" "application-repository" {
  repository_name = var.application-name
  description     = var.application-name

  tags = {
    Project = var.application-name
  }
}

# now send message based on a pull request created event
data "template_file" "pull-request-created-template" {
  template = file("codecommit-pull-request-created.tpl")
}

module "cicd-pipeline-dev-build-failed-notification" {
  source = "./cicd-notification"

  name = "${var.application-name}-pullrequest-created"
  slack-url = var.slack-url-failed

  message =<<EOT
  A pull request has been created:https://console.aws.amazon.com/codesuite/codecommit/repositories/${var.application-name}/pull-requests?region=us-east-1&status=OPEN&pull-requests-state=%7B%22f%22%3A%7B%22text%22%3A%22%22%7D%2C%22s%22%3A%7B%7D%2C%22n%22%3A10%2C%22i%22%3A0%7D
EOT

  subject = "Pull Request Created for repo: ${var.application-name}"

  rule = data.template_file.pull-request-created-template.rendered
}
