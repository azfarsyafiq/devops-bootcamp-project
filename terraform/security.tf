# =========================
# PUBLIC SECURITY GROUP
# =========================

resource "aws_security_group" "devops-public-sg" {
  name   = "devops-public-sg"
  vpc_id = module.my_vpc.vpc_id 

  tags = {
    Name = "devops-public-sg"
  }
}

# Port 80 from anywhere
resource "aws_vpc_security_group_ingress_rule" "public_http" {
  security_group_id = aws_security_group.devops-public-sg.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80
}

# Port 22 from VPC subnet
resource "aws_vpc_security_group_ingress_rule" "public_ssh" {
  security_group_id = aws_security_group.devops-public-sg.id

  cidr_ipv4   = module.my_vpc.vpc_cidr_block 
  ip_protocol = "tcp"
  from_port   = 22
  to_port     = 22
}

# Outbound
resource "aws_vpc_security_group_egress_rule" "public_outbound" {
  security_group_id = aws_security_group.devops-public-sg.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}


# =========================
# PRIVATE SECURITY GROUP
# =========================

resource "aws_security_group" "devops-private-sg" {
  name   = "devops-private-sg"
  vpc_id = module.my_vpc.vpc_id 
  tags = {
    Name = "devops-private-sg"
  }
}

 /* # Port 9100 from monitoring server

resource "aws_vpc_security_group_ingress_rule" "public_monitoring" {

  security_group_id = aws_security_group.devops-public-sg.id


  cidr_ipv4   = "MONITORING_SERVER_IP/32"

  ip_protocol = "tcp"

  from_port   = 9100

  to_port     = 9100

} */ 

# Port 22 from VPC subnet
resource "aws_vpc_security_group_ingress_rule" "private_ssh" {
  security_group_id = aws_security_group.devops-private-sg.id

  cidr_ipv4   = module.my_vpc.vpc_cidr_block # Fixed: was module.my_vpc.my_vpc.cidr_block
  ip_protocol = "tcp"
  from_port   = 22
  to_port     = 22
}

# Outbound
resource "aws_vpc_security_group_egress_rule" "private_outbound" {
  security_group_id = aws_security_group.devops-private-sg.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}