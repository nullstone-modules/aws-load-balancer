resource "aws_s3_bucket" "default" {
  bucket        = var.name
  force_destroy = var.force_destroy
  tags          = merge({ Name : var.name }, var.tags)
}

resource "aws_s3_bucket_ownership_controls" "default" {
  bucket = aws_s3_bucket.default.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_versioning" "default" {
  bucket = aws_s3_bucket.default.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "default" {
  bucket = aws_s3_bucket.default.bucket

  rule {
    id     = "log"
    status = "Enabled"

    abort_incomplete_multipart_upload {
      days_after_initiation = 5
    }

    expiration {
      days = 90
    }

    noncurrent_version_expiration {
      noncurrent_days = 90
    }

    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "GLACIER"
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.default.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
