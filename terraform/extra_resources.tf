resource "aws_s3_bucket" "example" {
  bucket = "my-cortex-demo-bucket-unique-id"
  tags = {
    yor_trace = "e9b36996-e341-4c1b-8921-eb0f0f339d80"
  }
}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  tags = {
    yor_trace = "b02be4af-285e-4309-afee-7ef4e4d31171"
  }
}

resource "aws_vpc" "main" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name      = "terraform-aws-vpc"
    yor_trace = "39302128-43cd-48be-91de-c0e9a0500b60"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name      = "terraform-aws-subnet"
    yor_trace = "3fddb010-9227-45ff-ac56-5aa8a8e3f9ee"
  }
}

