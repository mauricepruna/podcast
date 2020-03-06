variable "bucket_name" {
  type = string
  default = "mp3-repository-bucket"
}

variable "path_to_index"{
  type = string
  default = "files/index.html"
}

resource "aws_s3_bucket" "audio_repository" {
  bucket = var.bucket_name
  acl    = "public-read"
  policy = <<EOF
{
 
  "Version": "2012-10-17",
  "Statement": [
     {
      "Action": [
        "s3:ListBucket"
      ],
      "Effect": "Allow",
       "Principal": "*",
      "Resource": [
        "arn:aws:s3:::${var.bucket_name}"
      ]
    },
    {
   
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
        "Principal": "*",
      "Resource": "arn:aws:s3:::${var.bucket_name}/*"
    }
  ]
}
EOF
    force_destroy = true
}


resource "aws_s3_bucket_object" "index_file" {
  bucket = var.bucket_name
  key    = "index.html"
  source = var.path_to_index

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5(var.path_to_index)
  depends_on = [aws_s3_bucket.audio_repository]
}

output "audio_repository_endpoint" {
  value = "https://${var.bucket_name}.s3.amazonaws.com/index.html"
}


