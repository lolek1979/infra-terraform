# Infra-Terraform

This repository contains modular, reusable Terraform configurations to deploy infrastructure components like **ArgoCD**, **GitLab**, and **Jenkins** into a Kubernetes cluster using Helm and native Kubernetes resources.

---

## 📁 Project Structure

```
infra-terraform/
├── modules/
│   ├── argocd/              # ArgoCD Helm deployment
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── argocd-values.yaml
│   ├── gitlab/              # GitLab Helm deployment
│   │   ├── main.tf
│   │   └── gitlab-values.yaml
│   └── jenkins/             # Jenkins Deployment + PVC + Service
│       └── main.tf
├── environments/
│   └── dev/
│       └── main.tfvars      # Dev-specific overrides (e.g. namespace)
├── main.tf                  # Root Terraform config to load modules
├── providers.tf             # Provider configuration
├── backend.tf               # (Optional) backend config
├── .gitignore
└── README.md
```

---

## 🔧 Requirements

- Terraform >= 1.0
- A running Kubernetes cluster (e.g. Minikube, Kind, OrbStack, EKS)
- Helm access via Terraform (configured in `providers.tf`)
- `~/.kube/config` correctly pointing to the target cluster

---

## 🚀 How to Use

### 1. Clone the repository

```bash
git clone https://github.com/your-username/infra-terraform.git
cd infra-terraform
```

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Plan the infrastructure

Without variables file (uses default values):

```bash
terraform plan
```

With environment-specific overrides:

```bash
terraform plan -var-file=environments/dev/main.tfvars
```

### 4. Apply the infrastructure

```bash
terraform apply -var-file=environments/dev/main.tfvars
```

---

## 🧩 Module Overview

### ArgoCD

- Helm install of ArgoCD into a Kubernetes namespace
- Values customizable via `argocd-values.yaml`
- Parameters:
  - `namespace`
  - `chart_version`
  - `values_file_path`

### GitLab

- Helm install of GitLab using official chart
- Includes cert-manager email as override block
- Parameters:
  - `namespace`
  - `chart_version`
  - `values_file_path`
  - `cert_email`

### Jenkins

- Native Deployment + PVC + NodePort service
- Parameters:
  - `namespace`
  - `replicas`
  - `storage_size`
  - `node_port`
  - `image`

---

## 🔐 Secrets & Backends

You may configure `backend.tf` to use remote state (e.g., AWS S3, Terraform Cloud) if needed.

---
## RUN

terraform init       # if not already initialized
terraform plan       # review what will be created
terraform apply      # deploy just ArgoCD

# OR

terraform plan -target=module.argocd
terraform apply -target=module.argocd