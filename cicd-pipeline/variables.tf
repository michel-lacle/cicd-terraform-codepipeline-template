variable "application-name" {
  type = string
  description = "the name of the application this cicd is going to build"
}

variable "branch" {
  type = string
  description = "the source code branch to build"
}

variable "repository-name" {
  type = string
  description = "the name of the codecommit repository"
}

variable "slack-url" {
  type = string
  description = "the slack url to provide"
}