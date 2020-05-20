# variable "repo_bucket_name" {
#   type = string
#   default = "smatl-repository-bucket"
# }
# variable "podcast_bucket_name" {
#   type = string
#   default = "smatl-podcast-bucket"
# }

# variable "path_to_index"{
#   type = string
#   default = "files/index.html"
# }

# resource "aws_s3_bucket" "podcast_xml_bucket" {
#   bucket = var.podcast_bucket_name
#   acl    = "public-read"
#   policy = <<EOF
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Sid": "PublicReadGetObject",
#             "Effect": "Allow",
#             "Principal": "*",
#             "Action": "s3:GetObject",
#             "Resource": "arn:aws:s3:::${var.podcast_bucket_name}/*"
#         },
#         {
#             "Effect": "Allow",
#             "Principal": "*",
#             "Action": "s3:ListBucket",
#             "Resource": "arn:aws:s3:::${var.podcast_bucket_name}"
#         }
#     ]
# }
# EOF
#   website {
#     index_document = "podcast.xml"
#   }
# }
# resource "aws_s3_bucket" "audio_repository_bucket" {
#   bucket = var.repo_bucket_name
#   acl    = "public-read"
#   policy = <<EOF
# {
 
#   "Version": "2012-10-17",
#   "Statement": [
#      {
#       "Action": [
#         "s3:ListBucket"
#       ],
#       "Effect": "Allow",
#        "Principal": "*",
#       "Resource": [
#         "arn:aws:s3:::${var.repo_bucket_name}"
#       ]
#     },
#     {
   
#       "Action": [
#         "s3:GetObject"
#       ],
#       "Effect": "Allow",
#         "Principal": "*",
#       "Resource": "arn:aws:s3:::${var.repo_bucket_name}/*"
#     }
#   ]
# }
# EOF
# website {
#     index_document = "index.html"
#   }
#     force_destroy = true
# }

# resource "aws_s3_bucket_object" "index_file" {
#   bucket = var.repo_bucket_name
#   key    = "index.html"
#   source = var.path_to_index
#   content_type = "text/html"

#   # The filemd5() function is available in Terraform 0.11.12 and later
#   # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
#   # etag = "${md5(file("path/to/file"))}"
#   etag = filemd5(var.path_to_index)
#   depends_on = [aws_s3_bucket.audio_repository_bucket]
# }

# output "audio_repository_endpoint" {
#   value = "https://${var.repo_bucket_name}.s3.amazonaws.com/index.html"
# }


