provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "192.168.2.0/24"

  tags = {
    Name = "Drift-Demo-BOT"
  }
}
