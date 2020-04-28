resource "aws_cloudwatch_event_rule" "code-pipeline-stage-change" {
  name        = "codepipeline-events-${var.application-name}-${var.branch}"

  event_pattern = <<-EOT
{
  "source": [
    "aws.codepipeline"
  ],
  "detail-type": [
    "CodePipeline Pipeline Execution State Change"
  ],
  "detail": {
    "pipeline": ["${aws_codepipeline.codepipeline.name}"]
  }
}
EOT
}

resource "aws_cloudwatch_event_target" "lambda-event-target" {
  rule      = aws_cloudwatch_event_rule.code-pipeline-stage-change.name
  target_id = "SendToLambda"
  arn       = aws_lambda_function.notification-lambda-function.arn
}

resource "aws_lambda_permission" "cloudwatch-lambda-permission" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.notification-lambda-function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.code-pipeline-stage-change.arn
}
