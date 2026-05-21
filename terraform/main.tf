provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "192.168.2.0/24"

  tags = {
    Name      = "Drift-Demo-BOT"
    yor_trace = "9c054a45-33a0-45fa-bd7f-a02e541d4322"
  }
}

resource "aws_s3_bucket" "drift_demo" {
  bucket = "aschnitzer-drift-detection-bot"

  tags = {
    Name      = "Drift-Demo-BOT"
    yor_trace = "4c437bd6-7650-425b-8129-b8d30c379edb"
  }
}

resource "aws_s3_bucket_ownership_controls" "drift_demo" {
  bucket = aws_s3_bucket.drift_demo.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "drift_demo" {
  bucket = aws_s3_bucket.drift_demo.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "drift_demo" {
  depends_on = [
    aws_s3_bucket_ownership_controls.drift_demo,
    aws_s3_bucket_public_access_block.drift_demo,
  ]

  bucket = aws_s3_bucket.drift_demo.id
  acl    = "public-read"
}
