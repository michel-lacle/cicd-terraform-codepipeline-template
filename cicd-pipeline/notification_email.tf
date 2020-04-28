resource "aws_sns_topic" "pipeline-succeeded-email-topic" {
  name = "codepipeline-succeeded-email-${var.application-name}-${var.branch}"
}