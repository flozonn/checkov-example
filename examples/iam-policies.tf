# Example IAM policies for testing wildcard detection

# BAD: Policy with wildcard in actions
resource "aws_iam_policy" "bad_wildcard_actions" {
  name        = "bad-wildcard-actions"
  description = "Policy with wildcard in actions - should trigger alarm"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:*",  # This wildcard should trigger an alarm
          "ec2:*"  # This wildcard should trigger an alarm
        ]
        Resource = "arn:aws:s3:::my-bucket/*"
      }
    ]
  })
}

# BAD: Policy with wildcard in resources
resource "aws_iam_policy" "bad_wildcard_resources" {
  name        = "bad-wildcard-resources"
  description = "Policy with wildcard in resources - should trigger alarm"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = "*"  # This wildcard should trigger an alarm
      }
    ]
  })
}

# BAD: Policy with wildcards in both actions and resources
resource "aws_iam_policy" "bad_wildcard_both" {
  name        = "bad-wildcard-both"
  description = "Policy with wildcards in both actions and resources - should trigger alarm"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "*"     # This wildcard should trigger an alarm
        Resource = "*"   # This wildcard should trigger an alarm
      }
    ]
  })
}

# GOOD: Policy with specific actions and resources
resource "aws_iam_policy" "good_specific_policy" {
  name        = "good-specific-policy"
  description = "Policy with specific actions and resources - should pass"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          "arn:aws:s3:::my-specific-bucket/*",
          "arn:aws:s3:::my-specific-bucket"
        ]
      }
    ]
  })
}

# GOOD: Policy with limited scope
resource "aws_iam_policy" "good_limited_scope" {
  name        = "good-limited-scope"
  description = "Policy with limited scope - should pass"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeImages",
          "ec2:DescribeSnapshots"
        ]
        Resource = "arn:aws:ec2:us-west-2:123456789012:instance/i-1234567890abcdef0"
      }
    ]
  })
}