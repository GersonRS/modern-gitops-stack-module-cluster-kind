resource "kind_cluster" "cluster" {
  name = var.cluster_name

  node_image = "kindest/node:${var.kubernetes_version}"

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"
      kubeadm_config_patches = [
        # "kind: ClusterConfiguration\napiServer:\n  extraArgs:\n    \"service-account-issuer\": \"https://kubernetes.default.svc\"\n    \"service-account-signing-key-file\": \"/etc/kubernetes/pki/sa.key\"\n"
        "kind: InitConfiguration\nnodeRegistration:\n  kubeletExtraArgs:\n    node-labels: \"ingress-ready=true\"\n",
        {
          kind = "ClusterConfiguration"
          apiServer = {
            extraArgs = {
              "service-account-issuer" : "https://kubernetes.default.svc"
              "service-account-signing-key-file" : "/etc/kubernetes/pki/sa.key"
            }
          }
        }
      ]
    }

    dynamic "node" {
      for_each = var.nodes
      content {
        role   = "worker"
        labels = node.value
      }
    }
  }
}

data "docker_network" "kind" {
  name       = "kind"
  depends_on = [kind_cluster.cluster]
}
