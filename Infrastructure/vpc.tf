resource "aws_vpc" "lab-vpc" { // Define a VPC resource named "lab-vpc"
  cidr_block = "10.0.0.0/16"

  tags = {
    Name        = "lab VPC"
    Environment = "Production"
  }
}
resource "aws_security_group" "allow_tls" { // Create a security group that allows inbound TLS traffic
  name        = "allow-tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.lab-vpc.id
  ingress { // Allow inbound traffic on port 443 (HTTPS) from any source
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress { // Allow all outbound traffic from the security group
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { // Tag the security group for identification
    Name        = "allow-tls"
    Environment = "Production"
  }
}