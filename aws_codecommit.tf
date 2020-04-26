resource "aws_codecommit_repository" "terraform-codepipeline-template" {
  repository_name = "terraform-codepipeline-template"
  description     = "terraform-codepipeline-template"
}
