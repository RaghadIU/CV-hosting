provider "aws" {
  region = "us-east-1" 
}

resource "aws_s3_bucket" "cv_bucket" {
  bucket = "raghad-cv-hosting-bucket"  

  website {
    index_document = "index.html"
    error_document = "index.html"
  }

  tags = {
    Name = "CV Hosting Bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.cv_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "cv_policy" {
  bucket = aws_s3_bucket.cv_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.cv_bucket.arn}/*"
      }
    ]
  })
}

resource "aws_s3_bucket_object" "index" {
  bucket = aws_s3_bucket.cv_bucket.id
  key    = "index.html"
  source = "index.html"
  content_type = "text/html"
  etag = filemd5("index.html")
}

output "website_url" {
  value = aws_s3_bucket.cv_bucket.website_endpoint
}
