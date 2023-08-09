data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "role" {
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  name               = var.aws_rolename
}

resource "aws_iam_role_policy_attachment" "basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.role.name
}

resource "aws_iam_policy" "add_policy_one"{
    name        = "sns_publish_policy"
    policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "PublishSNSMessage",
                "Effect": "Allow",
                "Action": "sns:Publish",
                "Resource": "${aws_sns_topic.tst.arn}"
            }
        ]
    })
    tags = {
        Notes = "Created for providing Lambda read and write permissions on the SNS Topic"
    }
}

data "aws_iam_policy" "impawsmanagedpolicy" {
  arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}

resource "aws_iam_role_policy_attachment" "additional_one" {
    policy_arn = aws_iam_policy.add_policy_one.arn
    role       = aws_iam_role.role.name
}

resource "aws_iam_role_policy_attachment" "additional_two" {
    policy_arn = data.aws_iam_policy.impawsmanagedpolicy.arn
    role       = aws_iam_role.role.name
}

