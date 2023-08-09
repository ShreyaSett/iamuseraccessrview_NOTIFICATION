resource "aws_lambda_function" "tst_lmbda"{
    filename      = "../iamuser_notification.zip"
    function_name = var.aws_ld
    source_code_hash = filebase64sha256("../iamuser_notification.zip")
    role          = aws_iam_role.role.arn
    handler = "iamuser_notification.lambda_handler"
    runtime = "python3.9"
    timeout ="120"
    depends_on = [ aws_sns_topic.tst ]
    environment {
        variables = {
            snsarn = aws_sns_topic.tst.arn
        }
    }
}