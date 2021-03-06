
resource "aws_cloudwatch_event_rule" "notification-rule" {
  name        = var.name

  event_pattern = var.rule
}

resource "aws_cloudwatch_event_target" "lambda-event-target" {
  rule      = aws_cloudwatch_event_rule.notification-rule.name
  target_id = "SendToLambda"
  arn       = aws_lambda_function.notification-lambda-function.arn
}

resource "aws_lambda_permission" "cloudwatch-lambda-permission" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.notification-lambda-function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.notification-rule.arn
}
