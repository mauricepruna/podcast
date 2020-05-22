locals{
  lambda_role_policy_name = "podcast-lambda"
}

resource "aws_iam_role" "podcast_lambda_role" {
  name = local.lambda_role_policy_name

  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

resource "aws_iam_policy" "lambda_policy"{
  name = local.lambda_role_policy_name
  policy= data.aws_iam_policy_document.lamnda_policy.json
}

resource "aws_iam_role_policy_attachment" "podcast_lambda" {
  role       = aws_iam_role.podcast_lambda_role.name
  policy_arn =  aws_iam_policy.lambda_policy.arn
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

data "aws_iam_policy_document" "lamnda_policy"{
  statement{
    actions = [ 
            "logs:DescribeLogsStreams",
            "logs:PutLogEvents",
            "logs:CreateLogGroup",
            "logs:CreateLogStream"]
    resources = ["arn:aws:logs:*:*:log-group:/aws/lambda/podcast-lambda:log-stream:*"]
  }
}

resource "aws_lambda_function" "podcast_lambda" {
  function_name = "podcast-lambda"
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  role    = aws_iam_role.podcast_lambda_role.arn
  handler = "app-lambda"
  runtime = "go1.x"

  # environment {
  #   variables = {
  #     greeting = "Hello"
  #   }
  # }
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "../app/app-lambda"
  output_path = "../build/app.zip"
}