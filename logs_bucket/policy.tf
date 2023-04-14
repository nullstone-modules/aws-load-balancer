resource "aws_s3_bucket_acl" "default" {
  depends_on = [aws_s3_bucket_ownership_controls.default]

  bucket = aws_s3_bucket.default.id
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_policy" "default" {
  bucket = aws_s3_bucket.default.bucket
  policy = data.aws_iam_policy_document.this.json
}

data "aws_elb_service_account" "this" {}

data "aws_iam_policy_document" "this" {
  statement {
    sid = ""

    principals {
      type        = "AWS"
      identifiers = [join("", data.aws_elb_service_account.this.*.arn)]
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

resource "aws_s3_bucket_public_access_block" "default" {
  bucket = aws_s3_bucket.default.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
