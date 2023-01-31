resource "kubernetes_deployment" "grafana" {
	metadata {
		name = "grafana"
		namespace = kubernetes_namespace.dapr_monitoring.id
		labels = {
			name = "grafana"
		}
	}
	spec {
		replicas = 1
		selector {
			match_labels = {
				name = "grafana"
			}
		}
		template {
			metadata {
				labels = {
					name = "grafana"
				}
			}
			spec {
				container {
					image = "grafana/grafana:latest"
					name = "grafana-container"
					port {
						container_port = 3000
					}
					env {
						name = "GF_AUTH_BASIC_ENABLED"
						value = "true"
					}
					env {
						name = "GF_AUTH_ANONYMOUS_ENABLED"
						value = "false"
					}
				}
			}
		}
	}
}

resource "kubernetes_service" "grafana_service" {
	metadata {
		name = "grafana-service"
		namespace = kubernetes_namespace.dapr_monitoring.id
	}
	spec {
		selector = {
			name = kubernetes_deployment.grafana.spec.0.template.0.metadata.0.labels.name
		}
		port {
			port = kubernetes_deployment.grafana.spec.0.template.0.spec.0.container.0.port.0.container_port
			target_port = kubernetes_deployment.grafana.spec.0.template.0.spec.0.container.0.port.0.container_port
		}
	}
}
