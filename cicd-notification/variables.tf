variable "name" {
  type = string
}

variable "codepipeline-name" {
  type = string
  description = "the name of the codepipeline to monitor"
}

variable "slack-url" {
  type = string
  description = "the slack url to provide"
}

variable "message" {
  type = string
}

variable "subject" {
  type = string
}

variable "rule" {
  type = string
}