resource "aws_s3_bucket" "example" {
  bucket = "my-cortex-demo-bucket-unique-id"
}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}
