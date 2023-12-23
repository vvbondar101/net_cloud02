# resource "yandex_lb_network_load_balancer" "nlb01" {
#   name = "nlbsrv"
#   deletion_protection = false
#   depends_on = [
#     yandex_compute_instance_group.ig-1
#   ]
#   listener {
#     name = "listener01"
#     port = 80
    
#   }
#   attached_target_group {
#     target_group_id = yandex_compute_instance_group.ig-1.load_balancer.0.target_group_id
#     healthcheck {
#       name = "healthcheck"
#       http_options {
#         port = 80
#         path = ""
#       }
#     }
#   }
# }
