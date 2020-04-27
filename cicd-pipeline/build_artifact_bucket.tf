resource "aws_s3_bucket" "cicd-artifact-s3-bucket" {
  bucket = "cicd-artifacts-${var.application-name}-${var.branch}"
  acl = "private"
}