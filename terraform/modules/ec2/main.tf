resource "aws_security_group" "ec2_sg" {
  name        = "${var.name_prefix}-sg"
  description = "Allow SSH from specific CIDR"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.allowed_cidr_block]
  }

  tags = {
    Name = "${var.name_prefix}-sg"
  }
}

resource "aws_instance" "server" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  key_name                    = null #we will be using instance connect
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  root_block_device {
    volume_size = var.allocated_storage 
    volume_type = "gp3"
    encrypted   = true
  }
  associate_public_ip_address = true

  tags = {
    Name = "${var.name_prefix}-instance"
  }
}