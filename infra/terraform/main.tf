terraform {
  required_providers {
    kubernetes = { source = "hashicorp/kubernetes", version = ">= 2.0.0" }
    helm = { source = "hashicorp/helm", version = ">= 2.0.0" }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "kubernetes_namespace" "urlshort" {
  metadata { name = "urlshort" }
}
