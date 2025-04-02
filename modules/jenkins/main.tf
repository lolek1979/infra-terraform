variable "namespace" {
  type        = string
  default     = "jenkins"
  description = "Namespace where Jenkins will be deployed"
}

variable "replicas" {
  type        = number
  default     = 1
  description = "Number of Jenkins pods"
}

variable "image" {
  type        = string
  default     = "jenkins/jenkins:lts"
  description = "Jenkins Docker image"
}

variable "node_port" {
  type        = number
  default     = 32000
  description = "NodePort for exposing Jenkins"
}

variable "storage_size" {
  type        = string
  default     = "10Gi"
  description = "Storage size for Jenkins PVC"
}

resource "kubernetes_namespace" "jenkins" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_persistent_volume_claim" "jenkins_pvc" {
  metadata {
    name      = "jenkins-pvc"
    namespace = var.namespace
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = var.storage_size
      }
    }
  }
}

resource "kubernetes_deployment" "jenkins" {
  metadata {
    name      = "jenkins"
    namespace = var.namespace
    labels = {
      app = "jenkins"
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = "jenkins"
      }
    }

    template {
      metadata {
        labels = {
          app = "jenkins"
        }
      }

      spec {
        container {
          name  = "jenkins"
          image = var.image

          port {
            container_port = 8080
          }

          volume_mount {
            name       = "jenkins-home"
            mount_path = "/var/jenkins_home"
          }
        }

        volume {
          name = "jenkins-home"

          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.jenkins_pvc.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "jenkins" {
  metadata {
    name      = "jenkins-service"
    namespace = var.namespace
  }

  spec {
    selector = {
      app = "jenkins"
    }

    type = "NodePort"

    port {
      port        = 8080
      target_port = 8080
      node_port   = var.node_port
    }
  }
}