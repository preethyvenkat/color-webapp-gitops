terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.20.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "null_resource" "install_argocd" {
  provisioner "local-exec" {
    command = "kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml"
  }
  depends_on = [kubernetes_namespace.argocd]
}


resource "null_resource" "install_argo_rollouts" {
  provisioner "local-exec" {
    command = "kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-rollouts/stable/manifests/install.yaml"
  }
}
