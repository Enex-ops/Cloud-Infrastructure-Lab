resource "aws_s3_bucket" "frontend_bucket" {
  bucket = "gt3-cloud-frontend-bucket"

  tags = {
    Name        = "GT3 Cloud Frontend Bucket"
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