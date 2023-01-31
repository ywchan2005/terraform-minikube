resource "kubernetes_namespace" "application" {
	metadata {
		name = "application"
	}
}

resource "kubernetes_namespace" "dapr_monitoring" {
	metadata {
		name = "dapr-monitoring"
	}
}
