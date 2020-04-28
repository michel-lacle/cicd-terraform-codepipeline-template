variable "codepipeline-name" {
  type = string
  description = "the name of the codepipeline to monitor"
}

variable "slack-url" {
  type = string
  description = "the slack url to provide"
}

variable "s3-bucket-name" {
  type = string
  description = "the bucket that the user needs to get the zip files from"
}

variable "message" {
  type = string
}

variable "subject" {
  type = string
}