resource "kubernetes_namespace" "application" {
	metadata {
		name = "application"
	}
}
