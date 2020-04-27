resource "aws_codecommit_repository" "codecommit-repository" {
  repository_name = var.project-name
  description     = var.project-name

  tags = {
    Project = var.project-name
  }
}
