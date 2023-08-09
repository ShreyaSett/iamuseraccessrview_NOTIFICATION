variable "aws_eventrule" {
    description = "Rule for triggering lambda function for s3 versioning and sever access log collection"
}

variable "aws_rolename" {
    description = "Execution Role for Lambda"
}

variable "aws_ld" {
    description = "Lambda function name"
}

variable "aws_tg" {
    description = "Target s3 bucket"
    default = "targetbucket"
}

variable "aws_snstop" {
    description = "SNS Topic name"
}

variable "aws_snssub" {
    description = "SNS Subscriber endpoint email address"
}