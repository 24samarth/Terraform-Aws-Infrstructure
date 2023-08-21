#Security Group 
resource "aws_security_group" "sg" {
  vpc_id      = var.vpc_id
  name        = "${var.environment}-ec2SecurityGroup"
  description = "security group that allows ssh connection"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

  tags = {
    Name = "${var.environment}-SecurityGroup"
  }
}


output "security_group_id" {
  value = aws_security_group.sg.id
}


resource "aws_key_pair" "ssh_key_name" {
  key_name   = "${var.environment}-ssh_key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

# ec2-jumphost to connect to resources in private subnet
resource "aws_instance" "jumphost-ec2" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = element(var.public_subnets, 0)
  key_name                    = aws_key_pair.ssh_key_name.key_name
  associate_public_ip_address = true
  vpc_security_group_ids           = [aws_security_group.sg.id]
  tags = {
    Name = "${var.environment}-JumpHost"
  }
}