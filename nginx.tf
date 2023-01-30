resource "kubernetes_deployment" "nginx" {
	metadata {
		name = "nginx"
		namespace = kubernetes_namespace.application.id
		labels = {
			app = "my-test-app"
		}
	}
	spec {
		replicas = 2
		selector {
			match_labels = {
				app = "my-test-app"
			}
		}
		template {
			metadata {
				labels = {
					app = "my-test-app"
				}
			}
			spec {
				container {
					image = "nginx"
					name = "nginx-container"
					port {
						container_port = 80
					}
				}
			}
		}
	}
}

resource "kubernetes_service" "nginx_service" {
	metadata {
		name = "nginx-service"
		namespace = kubernetes_namespace.application.id
	}
	spec {
		selector = {
			app = kubernetes_deployment.nginx.spec.0.template.0.metadata.0.labels.app
		}
		# type = "NodePort"
		port {
			# node_port = 30080
			port = 30080
			target_port = kubernetes_deployment.nginx.spec.0.template.0.spec.0.container.0.port.0.container_port
		}
	}
}
