variable "application-name" {
  type = string
  default = "terraform-codepipeline-template"
  description = "the name of the application this cicd is going to build"
}

variable "branch" {
  type = string
  default = "master"
  description = "the source code branch to build"
}