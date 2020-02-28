resource "aws_s3_bucket" "audio_repository" {
  bucket = "mp3-repository-bucket"
  acl    = "private"

  tags = {
    Name        = "audio repository"

  }
}
