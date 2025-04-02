variable "namespace" {
  type        = string
  default     = "argocd"
  description = "Namespace where ArgoCD will be installed"
}

variable "chart_version" {
  type        = string
  default     = "4.10.1"
  description = "Version of the ArgoCD Helm chart"
}

variable "values_file_path" {
  type        = string
  description = "Path to custom values file"
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "argocd" {
  name             = "argocd"
  namespace        = kubernetes_namespace.argocd.metadata[0].name
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = var.chart_version
  create_namespace = true

  values = [file(var.values_file_path)]
}