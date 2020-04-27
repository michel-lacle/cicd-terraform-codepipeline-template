resource "aws_codecommit_repository" "terraform-codepipeline-template-codecommit" {
  repository_name = var.project-name
  description     = var.project-name

  tags = {
    Project = var.project-name
  }
}
