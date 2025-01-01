output "this" {
  value = aws_secretsmanager_secret.this
}

output "policy_arns" {
  value = { for k, v in module.policies : k => v.this.arn }
}

output "kubernetes_secret_provider_class_manifest" {
  value = {
    apiVersion = "secrets-store.csi.x-k8s.io/v1"
    kind       = "SecretProviderClass"
    metadata = {
      name      = aws_secretsmanager_secret.this.name
      namespace = var.kubernetes_manifest_namespace
    }
    spec = {
      provider = "aws"
      parameters = {
        region = data.aws_region.current.name
        objects = yamlencode([{
          objectName = aws_secretsmanager_secret.this.name
          objectType = "secretsmanager"
        }])
      }
    }
  }
}