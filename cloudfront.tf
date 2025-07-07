data "aws_s3_bucket" "cv_bucket" {
  bucket = "raghad-cv-hosting-bucket"
}

resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "raghad-oac"
  description                       = "Access control for S3 origin"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "cv_distribution" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront Distribution for CV Website"
  default_root_object = "index.html"

  origin {
    domain_name = data.aws_s3_bucket.cv_bucket.bucket_regional_domain_name
    origin_id   = "S3-raghad-origin"

    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-raghad-origin"

    viewer_protocol_policy = "redirect-to-https"

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

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name        = "raghad-cv-cloudfront"
    Environment = "Dev"
  }
}

output "cloudfront_url" {
  value = aws_cloudfront_distribution.cv_distribution.domain_name
}
