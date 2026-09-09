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

resource "aws_iam_policy" "ecr_ship" {
  name        = "EC2-ECR-Ship-Access"
  description = "Allow EC2 to login/push/pull only from ship ECR repository"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "ecr:GetAuthorizationToken"
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ]
        Resource = aws_ecr_repository.ship.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_ecr" {
  role       = "EC2-SSM-Role"
  policy_arn = aws_iam_policy.ecr_ship.arn
}

# Dynamic inventory aws_ec2 perlu kebenaran untuk list instance
resource "aws_iam_role_policy_attachment" "ec2_ec2_readonly" {
  role       = "EC2-SSM-Role"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}