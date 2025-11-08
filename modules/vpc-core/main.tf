locals {
  # Extract base name by removing '-vpc' suffix and use it to generate other resource names
  # Example: "myservice-proj01-dev-vpc" -> "myservice-proj01-dev"
  base_name = replace(var.vpc_name, "-vpc", "")

  # Generate resource names based on base name
  igw_name         = "${local.base_name}-igw"
  flow_log_name    = "${local.base_name}-flowlog"
  s3_bucket_name   = "${local.base_name}-flowlog-bucket"
  s3_bucket_prefix = "vpc-flow-logs/"
}

# VPC
resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge(
    var.tags,
    {
      Name = var.vpc_name
    }
  )
}

# Secondary CIDR Blocks
resource "aws_vpc_ipv4_cidr_block_association" "this" {
  for_each = toset(var.secondary_cidr_blocks)

  vpc_id     = aws_vpc.this.id
  cidr_block = each.value
}

# Internet Gateway
resource "aws_internet_gateway" "this" {
  count = var.enable_igw ? 1 : 0

  vpc_id = aws_vpc.this.id

  tags = merge(
    var.tags,
    {
      Name = local.igw_name
    }
  )
}

# S3 Bucket for VPC Flow Logs
resource "aws_s3_bucket" "this" {
  count = var.enable_flow_log ? 1 : 0

  bucket = local.s3_bucket_name

  tags = merge(
    var.tags,
    {
      Name = local.s3_bucket_name
    }
  )
}

# S3 Bucket Lifecycle Configuration
resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count = var.enable_flow_log ? 1 : 0

  bucket = aws_s3_bucket.this[0].id

  rule {
    id     = "expire-old-logs"
    status = "Enabled"

    expiration {
      days = var.flow_log_retention_days
    }
  }
}

# S3 Bucket Server Side Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  count = var.enable_flow_log ? 1 : 0

  bucket = aws_s3_bucket.this[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# S3 Bucket Public Access Block
resource "aws_s3_bucket_public_access_block" "this" {
  count = var.enable_flow_log ? 1 : 0

  bucket = aws_s3_bucket.this[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 Bucket Policy Document for VPC Flow Logs
data "aws_iam_policy_document" "this" {
  count = var.enable_flow_log ? 1 : 0

  statement {
    sid    = "AWSLogDeliveryWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    actions = ["s3:PutObject"]

    resources = ["${aws_s3_bucket.this[0].arn}/${local.s3_bucket_prefix}*"]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }

  statement {
    sid    = "AWSLogDeliveryAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    actions = ["s3:GetBucketAcl"]

    resources = [aws_s3_bucket.this[0].arn]
  }
}

# S3 Bucket Policy for VPC Flow Logs
resource "aws_s3_bucket_policy" "this" {
  count = var.enable_flow_log ? 1 : 0

  bucket = aws_s3_bucket.this[0].id
  policy = data.aws_iam_policy_document.this[0].json
}

# VPC Flow Log
resource "aws_flow_log" "this" {
  count = var.enable_flow_log ? 1 : 0

  vpc_id               = aws_vpc.this.id
  traffic_type         = "ALL"
  log_destination      = "${aws_s3_bucket.this[0].arn}/${local.s3_bucket_prefix}"
  log_destination_type = "s3"

  tags = merge(
    var.tags,
    {
      Name = local.flow_log_name
    }
  )
}
