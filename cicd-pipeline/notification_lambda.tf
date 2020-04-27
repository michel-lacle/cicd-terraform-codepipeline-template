variable "lambda-file" {
  type = string
  default = "notification_lambda.py"
}

variable "lambda-zip-file" {
  type = string
  default = "notification_lambda.zip"
}

provider "archive" {}

data "archive_file" "notification-lambda-file" {
  type = "zip"

  source_file = file("${path.module}/${var.lambda-file}")
  output_path = file("${path.module}/${var.lambda-zip-file}")
}

resource "aws_iam_role" "notification-lambda-iam-role" {
  name = "iam_for_lambda"

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
  filename      = var.lambda-zip-file
  function_name = "terraform-slack-notifier"
  role          = aws_iam_role.notification-lambda-iam-role.arn
  handler       = "notification_lambda.send_message"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256(var.lambda-zip-file)

  runtime = "python3.7"

  environment {
    variables = {
      SLACK_URL = var.slack-url
    }
  }

  depends_on = [data.archive_file.notification-lambda-file]
}
