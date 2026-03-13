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
  staticweb_domain = "FoxResumeSupreme.com"
}

data "aws_acm_certificate" "FoxResumeSupreme_com" {
  domain   = local.staticweb_domain
  statuses = ["ISSUED"] 
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
  default_root_object = "index.html"

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
      locations        = ["AU"]
    }
  }

  viewer_certificate {
    acm_certificate_arn            = data.aws_acm_certificate.FoxResumeSupreme_com.arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
  }
}

 data "aws_route53_zone" "staticweb_zone" {
    name         = local.staticweb_domain
    private_zone = false
  }



resource "aws_route53_record" "staticweb_record" {
    for_each = aws_cloudfront_distribution.s3_distribution.aliases
    zone_id = data.aws_route53_zone.staticweb_zone.zone_id
    name    = local.staticweb_domain
    type    = "CNAME"
    ttl     = 300
    records = [aws_cloudfront_distribution.s3_distribution.domain_name]

    alias {
      name = aws_cloudfront_distribution.s3_distribution.domain_name
      zone_id = aws_cloudfront_distribution.s3_distribution_zone_id
      evaluate_target_health = false
    }
}