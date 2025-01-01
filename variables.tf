variable "name" {}

variable "policies" {
  type = map(object({
    api_version = optional(string, "2012-10-17")
    statement   = any
  }))
  default  = {}
  nullable = false
}

variable "value" {
  type    = string
  default = null
}

variable "kubernetes_manifest_namespace" {
  default  = "default"
  nullable = false
}