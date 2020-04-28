locals {
  lambda-file = "${path.module}/notification_lambda.py"
  lambda-zip =  "${path.module}/notification_lambda.zip"
}

data "archive_file" "notification-lambda-file" {
  type = "zip"

  source_file = local.lambda-file
  output_path = local.lambda-zip
}


resource "aws_iam_role" "notification-lambda-iam-role" {
  name = "codepipeline-lambda-${var.codepipeline-name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


resource "aws_lambda_function" "notification-lambda-function" {
  filename      = local.lambda-file
  function_name = "codepipeline-notification-${var.codepipeline-name}"
  role          = aws_iam_role.notification-lambda-iam-role.arn
  handler       = "notification_lambda.send_message"
  
  source_code_hash = filebase64sha256(local.lambda-zip)

  runtime = "python3.7"

  environment {
    variables = {
      SLACK_URL = var.slack-url
      BUILD_ARTIFACT_BUCKET = var.s3-bucket-name
      DEBUG = 1
      EMAIL_TOPIC_ARN = aws_sns_topic.pipeline-succeeded-email-topic.arn
    }
  }

  depends_on = [data.archive_file.notification-lambda-file]
}
