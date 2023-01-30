resource "kubernetes_ingress_v1" "ingress" {
	metadata {
		name = "ingress"
		namespace = kubernetes_namespace.application.id
		annotations = {
			"nginx.ingress.kubernetes.io/rewrite-target" = "/$1"
		}
	}
	spec {
		rule {
			http {
				path {
					backend {
						service {
							name = kubernetes_service.nginx_service.metadata.0.name
							port {
								number = kubernetes_service.nginx_service.spec.0.port.0.port
							}
						}
					}
					path = "/"
				}
			}
		}
	}
}
