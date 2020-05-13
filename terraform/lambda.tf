resource "aws_iam_role" "iam_role_podcast_lambda" {
  name = "iam_role_podcast_lambda"

  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

data "aws_iam_policy_document" "lambda_assume_role_policy" {
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
  function_name = "main"

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  role    = aws_iam_role.iam_role_podcast_lambda.arn
  handler = "lambda_handler"
  runtime = "go1.x"

  environment {
    variables = {
      greeting = "Hello"
    }
  }
}

# data "archive_file" "podcast_lambda_archive" {
#   type        = "zip"
#   source_file = "${path.module}/../src/lambda.go"
#   output_path = "${path.module}/../dist/lambda.go.zip"
# }

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "../build/app"
  output_path = "app.zip"
}