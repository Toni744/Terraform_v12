provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "apache" {
  bucket = "my-tf-backend-bucket"

  tags = {
    Name        = "My bucket"
    Environment = "Prod"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "server_encryption" {
 bucket = "aws_s3_bucket.apache.id"
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_object" "object" {
  bucket = "aws_s3_bucket_apache"
  key    = "index.html"
  source = "index.html"
}

resource "aws_iam_policy" "policy" {
  name        = "allow_policy"
  path        = "/"
  description = "Allow  policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject",
        ]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.apache.arn}/*"
      },
    ]
  })
}

resource "aws_iam_role" "test_role" {
  name = "test_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.test_role.id
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_instance" "apache_server" {
  ami = "ami-03025bb25a1de0fc2"
  instance_type = "t2.micro"
    
  tags = {
    Name = "Terraform Ec2"
  }
  user_data = file("apache.sh")
}
