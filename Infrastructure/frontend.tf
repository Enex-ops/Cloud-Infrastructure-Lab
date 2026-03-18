data "aws_iam_policy_document" "bucket_policy" {
  statement {
    sid    = "AllowCloudFrontAccess"
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

resource "aws_cloudfront_origin_access_control" "staticweb_oac" {
  name = "staticweb-oac"
  description = "Origin Access Control for CloudFront to access S3 bucket"
  signing_behavior = "always"
  signing_protocol = "sigv4"
  origin_access_control_origin_type = "s3"
}

resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for CloudFront to access S3 bucket"
}

resource "aws_s3_bucket_policy" "staticweb_bucket" {
  bucket = aws_s3_bucket.staticweb_bucket.id
  policy = data.aws_iam_policy_document.bucket_policy.json
}

resource "aws_s3_object" "camfox_html" {
  bucket = aws_s3_bucket.staticweb_bucket.id
  key    = "camclouddev.html"
  source = "camclouddev.html"
}

resource "aws_s3_object" "camfox_css" {
  bucket = aws_s3_bucket.staticweb_bucket.id
  key    = "camclouddev.css"
  source = "camclouddev.css"
}

locals {
  s3_origin_id     = "S3-staticweb-origin"
  staticweb_domain = "camfox.cloud"
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

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.staticweb_bucket.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/${aws_cloudfront_origin_access_identity.oai.id}"
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
     cloudfront_default_certificate = true
     ssl_support_method       = "sni-only"
     minimum_protocol_version = "TLSv1.2_2021"
  }
 }
 
 resource "aws_route53_zone" "staticweb_zone" {
  name = local.staticweb_domain
 }

 resource "aws_route53_record" "staticweb_record" {
  zone_id = aws_route53_zone.staticweb_zone.zone_id
  name    = "camfox.cloud"
  type    = "A"
 
 alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
 }

