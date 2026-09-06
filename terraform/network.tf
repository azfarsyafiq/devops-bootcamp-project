module "my_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0"

  name = "tf4-vpc"
  cidr = "10.0.0.0/24"
  azs  = ["ap-southeast-1a"]

  public_subnets  = ["10.0.0.0/25"]
  private_subnets = ["10.0.0.128/25"]

  enable_nat_gateway = true
  single_nat_gateway = true

  map_public_ip_on_launch = true
}

