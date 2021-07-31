data "aws_elb_service_account" "default" {}

data "aws_iam_policy_document" "default" {
  statement {
    sid = ""

    principals {
      type        = "AWS"
      identifiers = [join("", data.aws_elb_service_account.default.*.arn)]
    }

    effect = "Allow"

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::${var.name}/*",
    ]
  }
}

resource "aws_s3_bucket" "default" {
  bucket        = var.name
  acl           = "log-delivery-write"
  force_destroy = var.force_destroy
  policy        = data.aws_iam_policy_document.default.json

  tags = merge({ Name : var.name }, var.tags)

  versioning {
    enabled = true
  }

  lifecycle_rule {
    enabled                                = true
    abort_incomplete_multipart_upload_days = 5

    noncurrent_version_expiration {
      days = 90
    }

    noncurrent_version_transition {
      days          = 30
      storage_class = "GLACIER"
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }

    expiration {
      days = 90
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "default" {
  bucket = aws_s3_bucket.default.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
