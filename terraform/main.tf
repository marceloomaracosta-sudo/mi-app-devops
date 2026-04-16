provider "aws" {
  region = "us-east-2"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# KEY
resource "aws_key_pair" "mi_key" {
  key_name   = var.key_name
  public_key = file("mi-clave-2.pub")
}

# SECURITY GROUP
resource "aws_security_group" "mi_sg" {
  name   = "mi-sg"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2
resource "aws_instance" "mi_ec2" {
  ami           = "ami-07062e2a343acc423"
  instance_type = "t3.micro"

  key_name = aws_key_pair.mi_key.key_name

  vpc_security_group_ids = [aws_security_group.mi_sg.id]
  subnet_id              = data.aws_subnets.default.ids[0]

  user_data = file("user_data.sh")

  tags = {
    Name = "Servidor-DevOps"
  }
}