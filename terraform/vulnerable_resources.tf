resource "aws_security_group" "vulnerable_sg" {
  name        = "vulnerable-sg"
  description = "Security group with open ports for drift detection demo"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Open SSH to the world"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Open RDP to the world"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Vulnerable-SG"
  }
}

resource "aws_iam_policy" "vulnerable_policy" {
  name        = "vulnerable-admin-policy"
  description = "Overly permissive IAM policy for drift detection demo"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "*"
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_sqs_queue" "vulnerable_queue" {
  name                      = "vulnerable-queue"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10

  # Misconfiguration: No server-side encryption enabled
  # sqs_managed_sse_enabled = false (default is true in newer AWS provider versions, so we explicitly disable it or use old KMS approach)
  sqs_managed_sse_enabled = false

  tags = {
    Name = "Vulnerable-Queue"
  }
}

resource "aws_sqs_queue_policy" "vulnerable_queue_policy" {
  queue_url = aws_sqs_queue.vulnerable_queue.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "VulnerableQueuePolicy"
    Statement = [
      {
        Sid       = "AllowPublicAccess"
        Effect    = "Allow"
        Principal = "*"
        Action    = "sqs:*"
        Resource  = aws_sqs_queue.vulnerable_queue.arn
      }
    ]
  })
}
