resource "aws_codecommit_repository" "terraform-codepipeline-template-codecommit" {
  repository_name = "${var.project-name}-codecommit"
  description     = "${var.project-name}-codecommit"

  tags = {
    Project = var.project-name
  }
}
