provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_instance" "gns3_server" {
  ami                    = "ami-026c39f4021df9abe" # Ubuntu 24.04 LTS AMI ID
  instance_type          = "t3.xlarge" # インスタンスタイプ
  key_name               = var.key_name # キーペア
  subnet_id              = var.subnet_id  # 既存サブネット
  private_ip             = var.private_ip # 固定プライベートIP
  associate_public_ip_address = true      # パブリックIP有効
  vpc_security_group_ids = [aws_security_group.gns3_sg.id]

  root_block_device {
    volume_size = 50
    volume_type = "gp3"
  }

  user_data              = file("setup-gns3.sh")

  tags = {
    Name = "GNS3-Server"
    Project = "GNS3-Server"
  }
}

resource "aws_security_group" "gns3_sg" {
  name        = "gns3-server-sg"
  description = "Allow SSH and GNS3 Ports"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [var.allowed_cidr]
  }

  ingress {
    from_port = 3080
    to_port   = 3080
    protocol  = "tcp"
    cidr_blocks = [var.allowed_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
