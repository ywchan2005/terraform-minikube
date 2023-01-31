resource "kubernetes_deployment" "prometheus" {
	metadata {
		name = "prometheus"
		namespace = kubernetes_namespace.dapr_monitoring.id
		labels = {
			name = "prometheus"
		}
	}
	spec {
		replicas = 1
		selector {
			match_labels = {
				name = "prometheus"
			}
		}
		template {
			metadata {
				labels = {
					name = "prometheus"
				}
			}
			spec {
				# service_account_name = "prometheus"
				container {
					image = "quay.io/prometheus/prometheus:latest"
					name = "prometheus-container"
					port {
						container_port = 9090
					}
				}
			}
		}
	}
}

resource "kubernetes_service" "prometheus_service" {
	metadata {
		name = "prometheus-service"
		namespace = kubernetes_namespace.dapr_monitoring.id
	}
	spec {
		selector = {
			name = kubernetes_deployment.prometheus.spec.0.template.0.metadata.0.labels.name
		}
		port {
			port = kubernetes_deployment.prometheus.spec.0.template.0.spec.0.container.0.port.0.container_port
			target_port = kubernetes_deployment.prometheus.spec.0.template.0.spec.0.container.0.port.0.container_port
		}
	}
}
