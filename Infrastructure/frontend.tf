data "aws_iam_policy_document" "bucket_policy" {
  statement {
    sid = "AllowCloudFrontServicePrincipalReadWriteAccessToS3Bucket"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]

    resources = [
      "${aws_s3_bucket.staticweb_bucket.arn}/*"
    ]

    condition {
      test = "StringEquals"
      variable = "AWS:SourceArn"
      values = [aws_cloudfront_distribution.s3_distribution.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "staticweb_bucket" {
    bucket = aws_s3_bucket.staticweb_bucket.id
    policy = data.aws_iam_policy_document.bucket_policy.json
}

locals {
  s3_origin_id = "myS3Origin"
  my_domain = "FoxResumeSupreme.com"
}

data "aws_acm_certificate" "FoxResumeSupreme_com" {
  domain   = local.my_domain
  statuses = ["ISSUED"] 
}