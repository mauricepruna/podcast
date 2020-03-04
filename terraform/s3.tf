resource "aws_s3_bucket" "audio_repository" {
  bucket = "mp3-repository-bucket"
  acl    = "public-read"
  policy = data.aws_iam_policy_document.audio_repository_policy.json
  tags = {
    Name        = "audio repository"

  }
}
data "aws_iam_policy_document" "audio_repository_policy" {
  statement {
    sid = "PublicRead"

    actions = [
      "s3:GetObject"
    ]

    resources = ["arn:aws:s3:::mp3-repository-bucket/*"]
  }

  # statement {
  #   actions = [
  #     "s3:ListBucket",
  #   ]

  #   resources = [
  #     "arn:aws:s3:::mp3-repository-bucket/*"
  #   ]
  #   }
}
