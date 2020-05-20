resource "aws_iam_role" "podcast_lambda_role" {
  name = "podcast-lambda-role"

  assume_role_policy = data.aws_iam_policy_document.lambda_policy_document.json
}

data "aws_iam_policy_document" "lambda_policy_document" {
  statement {
    sid    = ""
    effect = "Allow"

    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }

    actions = ["sts:AssumeRole"]
  }
}


resource "aws_lambda_function" "podcast_lambda" {
  function_name = "test-lambda"
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  role    = aws_iam_role.podcast_lambda_role.arn
  handler = "app-lambda"
  runtime = "go1.x"

  environment {
    variables = {
      greeting = "Hello"
    }
  }
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "../app/app-lambda"
  output_path = "../build/app.zip"
}