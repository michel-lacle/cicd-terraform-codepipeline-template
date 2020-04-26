variable "project-name" {
  type = string
  default = "terraform-codepipeline-template"
  description = "the name of the project"
}

variable "branch" {
  type = string
  default = "master"
  description = "the branch to build"
}