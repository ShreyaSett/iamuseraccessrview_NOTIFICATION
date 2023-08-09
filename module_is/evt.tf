resource "aws_cloudwatch_event_rule" "tst_rule" {
    name = var.aws_eventrule
    description = "Schedule for Lambda Function"
    schedule_expression = "cron(00 08 * * ? *)"
}

resource "aws_cloudwatch_event_target" "schedule_lambda" {
    rule = aws_cloudwatch_event_rule.tst_rule.name
    target_id = "cw_iamuser_notification_lmbda"
    arn = aws_lambda_function.tst_lmbda.arn
}

resource "aws_lambda_permission" "allow_events_bridge_to_run_lambda" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.tst_lmbda.function_name
    principal = "events.amazonaws.com"
    source_arn = aws_cloudwatch_event_rule.tst_rule.arn
}