resource "aws_s3_bucket" "frontend_bucket" {
  bucket = "lab-cloud-frontend-bucket"

  tags = {
    Name        = "lab Cloud Frontend Bucket"
    Environment = "Production"
  }
}

resource "aws_dynamodb_table" "lab_example_bucket" {
  name         = "lab-example-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "lab Example Table"
    Environment = "Production"
  }
}

/*
 The bucket does not allow ACLs (AccessControlListNotSupported).
 ACLs are disabled by the account/bucket (Object Ownership = BucketOwnerEnforced).
 Access should be managed with a bucket policy or IAM permissions instead.
 Removed the aws_s3_bucket_acl resource to avoid API errors.
 */

resource "random_id" "bucket_name_suffix" {
  byte_length = 4
}