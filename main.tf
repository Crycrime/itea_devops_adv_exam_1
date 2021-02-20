provider "aws" {}

resource "aws_vpc" "ansible_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "ansible_vpc"
  }
}

resource "aws_security_group" "ansible_sg" {
  name        = "ansible_sg"
  description = "allow http"

  dynamic "ingress" {
    for_each = ["80", "22"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ansible_sg"
  }
}

resource "aws_security_group" "ansible_db_sg" {
  name        = "ansible_db_sg"
  description = "allow 3306 port"

  ingress {
    description = "open 3306 port"
    from_port   = 3306
    to_port     = 3306
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
    Name = "ansible_db_sg"
  }
}

resource "aws_instance" "ec2_ansible" {
  ami                    = "ami-0e80a462ede03e653" #Amazon Linux 2 AMI (HVM)
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ansible_sg.id]
  key_name               = "exam_project"

  tags = {
    Name = "Instance for ansible"
  }
}


resource "aws_eip" "my_static_ip" {
  instance = aws_instance.ec2_ansible.id

  tags = {
    Name = "Public IP"
  }
}
