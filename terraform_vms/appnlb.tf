resource "yandex_alb_backend_group" "backend-group" {
  name                     = "backendgroup"
  depends_on = [
    yandex_compute_instance_group.ig-1
  ]
  session_affinity {
    connection {
      source_ip = true
    }
  }

  http_backend {
    name                   = "backend"
    weight                 = 1
    port                   = 80
    target_group_ids       = [yandex_compute_instance_group.ig-1.application_load_balancer.0.target_group_id]
    load_balancing_config {
      panic_threshold      = 90
    }    
    healthcheck {
      timeout              = "10s"
      interval             = "2s"
      healthy_threshold    = 10
      unhealthy_threshold  = 15
      http_healthcheck {
        path               = "/"
      }
    }
  }
}

resource "yandex_alb_http_router" "tf-router" {
  name   = "httprouter"
  labels = {
    tf-label    = "tf-label-value"
    empty-label = ""
  }
}

resource "yandex_alb_virtual_host" "my-virtual-host" {
  name           = "virtualhost"
  http_router_id = yandex_alb_http_router.tf-router.id
  route {
    name = yandex_alb_http_router.tf-router.name
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.backend-group.id
        timeout          = "30s"
      }
    }
  }
}    

resource "yandex_alb_load_balancer" "test-balancer" {
  name        = "applb01"
  network_id  = "${yandex_vpc_network.cloudvpc.id}"
  depends_on = [
    yandex_compute_instance_group.ig-1
  ]
  allocation_policy {
    location {
      zone_id   = var.default_zone
      subnet_id = yandex_vpc_subnet.devnet.id
    }
  }

  listener {
    name = "listener01"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [ 80 ]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.tf-router.id
      }
    }
  }

}