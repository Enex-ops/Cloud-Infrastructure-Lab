resource "aws_s3_bucket" "frontend_bucket" {
  bucket = "gt3-cloud-frontend-bucket"

  tags = {
    Name        = "GT3 Cloud Frontend Bucket"
    Environment = "Production"
  }
}

resource "aws_s3_bucket_acl" "frontend_bucket_acl" {
  bucket = aws_s3_bucket.frontend_bucket.id
  acl    = "private" 
}

resource "random_id" "bucket_name_suffix" {
  byte_length = 4
}