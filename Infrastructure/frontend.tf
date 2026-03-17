data "aws_iam_policy_document" "bucket_policy" {
  statement {
    sid    = "AllowCloudFrontServicePrincipalReadWriteAccessToS3Bucket"
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
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.s3_distribution.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "staticweb_bucket" {
  bucket = aws_s3_bucket.staticweb_bucket.id
  policy = data.aws_iam_policy_document.bucket_policy.json
}

locals {
  s3_origin_id     = "myS3Origin"
  staticweb_domain = "camfox.cloud"
}


data "aws_acm_certificate" "staticweb_cert" {
  provider    = aws.us_east_1
  domain      = "camfox.cloud"
  most_recent = "true"
}

resource "aws_acm_certificate" "staticweb_cert" {
  provider          = aws.us_east_1
  validation_method = "DNS"
  domain_name       = "camfox.cloud"

  tags = {
    Name        = "lab Static Web Certificate"
    Environment = "Production"
  }
}

resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for CloudFront to access S3 bucket"

}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.staticweb_bucket.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront Distribution for S3 Static Website"
  default_root_object = "camclouddev.html"

  default_cache_behavior {
    target_origin_id       = local.s3_origin_id
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["AU", "US"]
    }
  }

  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.staticweb_cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}

data "aws_route53_zone" "staticweb_zone" {
  name         = local.staticweb_domain
  private_zone = false
}

resource "aws_route53_record" "staticweb_record" {
  for_each = {
    for robo in aws_acm_certificate.staticweb_cert.domain_validation_options : robo.domain_name => {
      name   = robo.resource_record_name
      type   = robo.resource_record_type
      record = robo.resource_record_value

    }
  }
  zone_id = data.aws_route53_zone.staticweb_zone.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]
}

resource "aws_acm_certificate_validation" "staticweb_cert_validation" {
  provider        = aws.us_east_1
  certificate_arn = aws_acm_certificate.staticweb_cert.arn
}
