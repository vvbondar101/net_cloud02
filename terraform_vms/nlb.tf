
resource "yandex_lb_target_group" "srvgroup" {
  name       = "serversgroup"
  depends_on = [
    yandex_compute_instance_group.ig-1
  ]
  target {
    subnet_id = yandex_vpc_subnet.devnet.id
    address   = yandex_compute_instance_group.ig-1.instances.0.network_interface.0.ip_address
  }
  target {
    subnet_id = yandex_vpc_subnet.devnet.id
    address   = yandex_compute_instance_group.ig-1.instances.1.network_interface.0.ip_address
  }
#   target {
#     subnet_id = yandex_vpc_subnet.devnet.id
#     address   = yandex_compute_instance_group.ig-1.instances.2.network_interface.0.ip_address
#   }
    # target {
    #     for_each = {for inst in yandex_compute_instance_group.ig-1.instances : inst.name => inst}
    #     subnet_id = yandex_vpc_subnet.devnet.id
    #     address = each.value.network_interface.0.ip_address
    # }
 
}

resource "yandex_lb_network_load_balancer" "nlb01" {
  name = "nlbsrv"
  deletion_protection = false
  depends_on = [
    yandex_lb_target_group.srvgroup
  ]
  listener {
    name = "listener01"
    port = 80
    
  }
  attached_target_group {
    target_group_id = yandex_lb_target_group.srvgroup.id
    healthcheck {
      name = "healthcheck"
      http_options {
        port = 80
        path = ""
      }
    }
  }
}
