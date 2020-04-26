resource "aws_codecommit_repository" "terraform-codepipeline-template-codecommit" {
  repository_name = "terraform-codepipeline-template-codecommit"
  description     = "terraform-codepipeline-template-codecommit"
}
