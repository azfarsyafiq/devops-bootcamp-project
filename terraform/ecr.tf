resource "aws_ecr_repository" "ship" {
  name                 = "ship"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "ship"
  }
}

# Node perlu kebenaran ECR untuk login/tolak/tarik imej
resource "aws_iam_role_policy_attachment" "ec2_ecr" {
  role       = "EC2-SSM-Role"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}