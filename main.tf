data "aws_region" "current" {}

resource "aws_secretsmanager_secret" "this" {
  name = var.name
}

resource "aws_secretsmanager_secret_policy" "this" {
  for_each   = var.policies
  secret_arn = aws_secretsmanager_secret.this.arn
  policy = jsonencode({
    Version   = each.value.api_version
    Statement = jsonencode(each.value.statement)
  })
}

resource "aws_secretsmanager_secret_version" "this" {
  count         = var.value == null ? 0 : 1
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = var.value
}

module "policies" {
  source  = "app.terraform.io/ptonini-org/iam-policy/aws"
  version = "~> 1.0.0"
  for_each = {
    getter = [{
      Effect   = "Allow"
      Action   = ["secretsmanager:GetSecretValue", "secretsmanager:DescribeSecret"]
      Resource = [aws_secretsmanager_secret.this.arn]
    }]
  }
  name      = "secret-${var.name}-${each.key}"
  statement = each.value
}