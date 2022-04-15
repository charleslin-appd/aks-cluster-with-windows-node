provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "appdynamics" {
  depends_on = [null_resource.local_k8s_context]
  name       = formatdate("YY.MM.DD", timestamp())    # Prefix of the cluster name <name>-appdynamics
  repository = "https://ciscodevnet.github.io/appdynamics-charts"
  chart      = "cluster-agent"
  namespace  = "appdynamics"
  create_namespace = true

  values = [
    file("${path.module}/../helm/values-ca1.yaml"),
    file("${path.module}/../helm/values-ca1-sensitive.yaml")
  ]
}

# resource "helm_release" "prometheus" {
#   depends_on = [null_resource.local_k8s_context]
#   name       = "prometheus"
#   #repository = "https://prometheus-community.github.io/helm-charts"
#   #chart      = "prometheus-community/kube-prometheus-stack"
#   #version    = "32.2.1"
#   # Error: could not download chart: chart "prometheus-community/kube-prometheus-stack" version "32.2.1" not found in https://prometheus-community.github.io/helm-charts repository
#   # Use local file instead
#   chart      = "kube-prometheus-stack-32.2.1.tgz"
#   namespace  = "prometheus"
#   create_namespace = true
# }
