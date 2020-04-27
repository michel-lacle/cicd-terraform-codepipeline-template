resource "aws_codecommit_repository" "codecommit-repository" {
  repository_name = var.application-name
  description     = var.application-name

  tags = {
    Project = var.application-name
  }
}
