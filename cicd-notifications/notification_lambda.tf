variable "lambda-file" {
  type = string
  default = "notification_lambda.py"
}

variable "lambda-zip-file" {
  type = string
  default = "notification_lambda.zip"
}



data "archive_file" "notification-lambda-file" {
  type = "zip"

  source_file = "${path.module}/${var.lambda-file}"
  output_path = "${path.module}/${var.lambda-zip-file}"
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
  filename      = "${path.module}/${var.lambda-zip-file}"
  function_name = "codepipeline-notification-${var.codepipeline-name}"
  role          = aws_iam_role.notification-lambda-iam-role.arn
  handler       = "notification_lambda.send_message"

  source_code_hash = filebase64sha256("${path.module}/${var.lambda-zip-file}")

  runtime = "python3.7"

  environment {
    variables = {
      DEBUG = "true"
      SLACK_URL = var.slack-url
      EMAIL_TOPIC_ARN = aws_sns_topic.pipeline-succeeded-email-topic.arn
      BUILD_ARTIFACT_BUCKET = var.s3-bucket-name
    }
  }

  depends_on = [data.archive_file.notification-lambda-file]
}
