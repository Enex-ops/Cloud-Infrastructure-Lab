resource "aws_cloudfront" "staticweb_distribution" {
  origin {
    domain_name = aws_s3_bucket.staticweb_bucket.bucket_regional_domain_name
    origin_id   = "S3-${aws_s3_bucket.staticweb_bucket.id}"
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront distribution for static web hosting"
  default_root_object = "index.html"

  default_cache_behavior {
    target_origin_id       = "S3-${aws_s3_bucket.staticweb_bucket.id}"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Name        = "lab Static Web Distribution"
    Environment = "Production"
  }
  
}