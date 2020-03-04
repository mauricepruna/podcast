variable "bucket_name" {
  type = string
  default = "mp3-repository-bucket"
}

resource "aws_s3_bucket" "audio_repository" {
  bucket = var.bucket_name
  acl    = "public-read"
  policy = <<EOF
{
 
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "bucket_policy_site_main",
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${var.bucket_name}/*",
      "Principal": "*"
    }
  ]
}
EOF
    website {
        index_document = "index.html"
        error_document = "404.html"
    }
    
    force_destroy = true
}
