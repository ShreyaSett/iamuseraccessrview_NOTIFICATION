resource "aws_sns_topic" "tst" {
  name            = var.aws_snstop
  delivery_policy = <<EOF
    {
        "http": {
            "defaultHealthyRetryPolicy": {
                "minDelayTarget": 20,
                "maxDelayTarget": 20,
                "numRetries": 3,
                "numMaxDelayRetries": 0,
                "numNoDelayRetries": 0,
                "numMinDelayRetries": 0,
                "backoffFunction": "linear"
            },
            "disableSubscriptionOverrides": false,
            "defaultRequestPolicy": {
                "headerContentType": "text/plain; charset=UTF-8"
            }
        }
    }
    EOF
}

resource "aws_sns_topic_subscription" "user_updates_email_target" {
  topic_arn = aws_sns_topic.tst.arn
  protocol  = "email"
  endpoint  = var.aws_snssub
}







