resource "aws_sns_topic" "pipeline-succeeded-email-topic" {
  name = "codepipeline-succeeded-email-${var.application-name}-${var.branch}"
}

data "aws_iam_policy_document" "pipeline-succeeded-policy-document" {

  statement {
    actions = [
      "sns:Publish"
    ]

    effect = "Allow"

    resources = [
      aws_sns_topic.pipeline-succeeded-email-topic.arn
    ]

    sid = "emailsnsid"
  }
}

resource "aws_iam_role_policy" "allow_lambda_to_publish_sns_topic" {
  policy = data.aws_iam_policy_document.pipeline-succeeded-policy-document.json
  role = aws_iam_role.notification-lambda-iam-role.id
}
