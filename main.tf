module "argocd" {
  source            = "./modules/argocd"
  namespace         = "argocd"
  chart_version     = "4.10.1"
  values_file_path  = "${path.module}/modules/argocd/argocd-values.yaml"
}

# module "gitlab" {
#   source            = "./modules/gitlab"
#   namespace         = "gitlab"
#   chart_version     = "6.3.0"
#   values_file_path  = "${path.module}/modules/gitlab/gitlab-values.yaml"
#   cert_email        = "p.konieczny@hotmail.com"
#   timeout           = 600
# }

module "jenkins" {
  source        = "./modules/jenkins"
  namespace     = "jenkins"
  image         = "jenkins/jenkins:lts"
  node_port     = 32000
  replicas      = 1
  storage_size  = "10Gi"
}