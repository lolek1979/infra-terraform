variable "namespace" {
  type        = string
  default     = "gitlab"
  description = "Namespace where GitLab will be deployed"
}

variable "chart_version" {
  type        = string
  default     = "6.3.0"
  description = "GitLab Helm chart version"
}

variable "values_file_path" {
  type        = string
  description = "Path to custom values file"
}

variable "cert_email" {
  type        = string
  default     = "example@example.com"
  description = "Email for cert-manager issuer (used in Helm values)"
}

variable "timeout" {
  type        = number
  default     = 600
  description = "Timeout for Helm release"
}

resource "kubernetes_namespace" "gitlab" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "gitlab" {
  name             = "gitlab"
  namespace        = kubernetes_namespace.gitlab.metadata[0].name
  repository       = "https://charts.gitlab.io"
  chart            = "gitlab"
  version          = var.chart_version
  timeout          = var.timeout
  create_namespace = true

  values = [
    file(var.values_file_path),
    <<EOF
certmanager-issuer:
  email: "${var.cert_email}"
EOF
  ]
}