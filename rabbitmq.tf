resource "kubernetes_deployment" "rabbitmq" {
	metadata {
		name = "rabbitmq"
		namespace = kubernetes_namespace.application.id
		labels = {
			name = "rabbitmq"
		}
	}
	spec {
		replicas = 1
		selector {
			match_labels = {
				name = "rabbitmq"
			}
		}
		template {
			metadata {
				labels = {
					name = "rabbitmq"
				}
			}
			spec {
				container {
					# image = "rabbitmq:latest"
					image = "rabbitmq:management"
					name = "rabbitmq-container"
					port {
						name = "amqp"
						container_port = 5672
					}
					port {
						name = "mgmt"
						container_port = 15672
					}
				}
			}
		}
	}
}

resource "kubernetes_service" "rabbitmq_service" {
	metadata {
		name = "rabbitmq-service"
		namespace = kubernetes_namespace.application.id
	}
	spec {
		selector = {
			name = kubernetes_deployment.rabbitmq.spec.0.template.0.metadata.0.labels.name
		}
		port {
			name = "amqp"
			port = kubernetes_deployment.rabbitmq.spec.0.template.0.spec.0.container.0.port.0.container_port
			target_port = kubernetes_deployment.rabbitmq.spec.0.template.0.spec.0.container.0.port.0.container_port
		}
		port {
			name = "mgmt"
			port = kubernetes_deployment.rabbitmq.spec.0.template.0.spec.0.container.0.port.1.container_port
			target_port = kubernetes_deployment.rabbitmq.spec.0.template.0.spec.0.container.0.port.1.container_port
		}
	}
}
