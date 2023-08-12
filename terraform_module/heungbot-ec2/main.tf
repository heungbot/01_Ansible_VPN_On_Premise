# bastion host instance

resource "aws_key_pair" "tf-main" {
  key_name   = "tf_main_key"
  public_key = file("${var.PUBLIC_KEY_PATH}")

  tags = {
    Name = "${var.APP_NAME}-main-key-pair"
  }
}

resource "aws_instance" "bastion" {
  ami                    = var.BASTION_AMI
  instance_type          = var.BASTION_TYPE
  subnet_id              = var.PUBLIC_SUBNET_ID
  vpc_security_group_ids = [aws_security_group.bastion-sg.id]
  key_name               = "tf_main_key"

  tags = {
    Name = "${var.APP_NAME}-bastion-host"
  }
}

resource "aws_security_group" "bastion-sg" {
  name   = "main-bastion-sg"
  vpc_id = var.VPC_ID

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = var.ADMIN_CIDR
  }

  ingress {
    from_port   = 0
    protocol    = "icmp"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"] # for test
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.APP_NAME}-bastion-sg"
  }
}

# ansible instance

resource "aws_instance" "ansible" {
  ami                    = var.ANSIBLE_AMI
  instance_type          = var.ANSIBLE_TYPE
  subnet_id              = var.PRIVATE_SUBNET_ID
  vpc_security_group_ids = [aws_security_group.ansible-sg.id]
  key_name               = "tf_main_key"

  tags = {
    Name = "${var.APP_NAME}-bastion-host"
  }
}


resource "aws_security_group" "ansible-sg" {
  name   = "main-bastion-sg"
  vpc_id = var.VPC_ID

  ingress {
    from_port       = 22
    protocol        = "tcp"
    to_port         = 22
    security_groups = [aws_security_group.bastion-sg.id]
  }
  ingress {
    from_port   = 0
    protocol    = "icmp"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"] # for test
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  depends_on = [aws_security_group.bastion-sg]

  tags = {
    Name = "${var.APP_NAME}-bastion-sg"
  }
}