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

resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.my_ami.id
  instance_type          = "t3.micro"
  subnet_id              = module.my_vpc.public_subnets[0]
  private_ip             = "10.0.0.5"
  vpc_security_group_ids = [aws_security_group.devops-public-sg.id]
  iam_instance_profile   = data.aws_iam_instance_profile.my_ssm_profile.name
  key_name               = "livyattan-keypair"
  tags = {
    Name = "web_server"
    Role = "devops-node"
  }
}

resource "aws_eip" "web-eip" {
  domain   = "vpc"
  instance = aws_instance.web_server.id

  tags = {
    Name = "web-server-eip"
  }
}

resource "aws_instance" "ansible_controller" {
  ami                    = data.aws_ami.my_ami.id
  instance_type          = "t3.micro"
  subnet_id              = module.my_vpc.private_subnets[0]
  private_ip             = "10.0.0.135"
  vpc_security_group_ids = [aws_security_group.devops-private-sg.id]
  key_name               = "livyattan-keypair"
  iam_instance_profile   = data.aws_iam_instance_profile.my_ssm_profile.name
  user_data              = file("userdata/ansible-controller.sh")

  tags = {
    Name = "ansible_controller"
  }
}

resource "aws_instance" "monitoring_server" {
  ami                    = data.aws_ami.my_ami.id
  instance_type          = "t3.micro"
  subnet_id              = module.my_vpc.private_subnets[0]
  private_ip             = "10.0.0.136"
  vpc_security_group_ids = [aws_security_group.devops-private-sg.id]
  key_name               = "livyattan-keypair"
  iam_instance_profile   = data.aws_iam_instance_profile.my_ssm_profile.name

  tags = {
    Name = "monitoring_server"
    Role = "devops-node"
  }
}