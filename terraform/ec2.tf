data "aws_ami" "my_ami" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

data "aws_iam_instance_profile" "my_ssm_profile" {
  name = "EC2-SSM-Role"
}

resource "aws_instance" "web-server" {
  ami                    = data.aws_ami.my_ami.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.devops-public-sg.id]
  iam_instance_profile   = data.aws_iam_instance_profile.my_ssm_profile.name

  tags = {
    Name = "tf-server-1"
  }
}

resource "aws_instance" "ansible-controller" {
  ami                    = data.aws_ami.my_ami.id
  instance_type          = "t3.micro"
  subnet_id              = aaws_subnet.my_private_subnet.id
  vpc_security_group_ids = [aws_security_group.devops-private-sg.id]
  iam_instance_profile   = data.aws_iam_instance_profile.my_ssm_profile.name

  tags = {
    Name = "tf-server-2"
  }
}

resource "aws_instance" "monitoring-server" {
  ami                    = data.aws_ami.my_ami.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.my_private_subnet.id
  vpc_security_group_ids = [aws_security_group.devops-private-sg.id]
  iam_instance_profile   = data.aws_iam_instance_profile.my_ssm_profile.name

  tags = {
    Name = "tf-server-private"
  }
}