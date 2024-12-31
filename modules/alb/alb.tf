################################################################################
# Application Load Balancer
################################################################################
resource "aws_lb" "this" {
  name               = "${var.env}-${var.system}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.this.id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = false // For demo purposes only

  access_logs {
    bucket  = aws_s3_bucket.this.bucket
    prefix  = "${var.env}-${var.system}-alb"
    enabled = true
  }

  tags = {
    Name      = "${var.env}-${var.system}-alb"
    CreatedBy = var.created_by
  }
}

################################################################################
# S3 Bucket for ALB Logs
################################################################################
resource "aws_s3_bucket" "this" {
  bucket = "${var.env}-${var.system}-alb-logs"
  acl    = "private"

  force_destroy = true // For demo purposes only

  tags = {
    Name      = "${var.env}-${var.system}-alb-logs"
    CreatedBy = var.created_by
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.this.bucket

  rule {
    id     = "log-lifecycle"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 60
      storage_class = "ONEZONE_IA"
    }

    expiration {
      days = 180
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.bucket
  policy = data.aws_iam_policy_document.this.json
}

data "aws_iam_policy_document" "this" {
  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.this.bucket}/*"]

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
  }
}

################################################################################
# Security Group for ALB
################################################################################
resource "aws_security_group" "this" {
  name   = "${var.env}-${var.system}-alb-sg"
  vpc_id = var.vpc_id

  tags = {
    Name      = "${var.env}-${var.system}-alb-sg"
    CreatedBy = var.created_by
  }
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.this.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = var.vpc_cidr_block

  description = "Allow HTTP traffic from VPC endpoints"
  tags = {
    Name      = "${var.env}-${var.system}-alb-sg-http"
    CreatedBy = var.created_by
  }
}

resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.this.id
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = var.vpc_cidr_block

  description = "Allow HTTPS traffic from VPC endpoints"
  tags = {
    Name      = "${var.env}-${var.system}-alb-sg-https"
    CreatedBy = var.created_by
  }
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.this.id
  from_port         = 0
  to_port           = 0
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"

  description = "Allow all outbound traffic to the internet"
  tags = {
    Name      = "${var.env}-${var.system}-alb-sg-all"
    CreatedBy = var.created_by
  }
}