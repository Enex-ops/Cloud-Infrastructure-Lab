terraform {
  backend "s3" {
    bucket         = "terraform-state-145023112872"
    key            = "global/s3/terraform.tfstate"
    region         = "ap-southeast-2"
    encrypt        = true
    use_lockfile = "true"
  }
}

resource "aws_vpc" "lab-vpc" {
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Name        = "lab VPC"
    Environment = "Production"
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "allow-tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.lab-vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
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
    Name        = "allow-tls"
    Environment = "Production"
  }
}