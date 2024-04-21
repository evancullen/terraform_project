provider "aws" {
  region = var.aws_region
}

# Create Lambda function
data "aws_s3_object" "lambda_function_code" {
  bucket = "bucket-states-dev"
  key    = "lambda_function_payload.zip"
}

resource "aws_lambda_function" "dev_lambda" {
  s3_bucket       = data.aws_s3_object.lambda_function_code.bucket
  s3_key          = data.aws_s3_object.lambda_function_code.key
  function_name   = "dev_lambda_function"
  role            = aws_iam_role.lambda_role.arn
  handler         = "lambda_function.handler"
  runtime         = "python3.8"
  
}


# Create IAM role for Lambda function
resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}

# Grant permission for CloudWatch Events to invoke Lambda function
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.dev_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_trigger.arn
}

# Create CloudWatch Events cron job
resource "aws_cloudwatch_event_rule" "lambda_trigger" {
  name                = "lambda_cron_trigger"
  schedule_expression = "rate(5 minutes)"
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule = aws_cloudwatch_event_rule.lambda_trigger.name
  arn  = aws_lambda_function.dev_lambda.arn
}
