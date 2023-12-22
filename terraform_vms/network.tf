resource "yandex_vpc_network" "cloudvpc" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "devnet" {
  name           = var.devnet
  zone           = var.default_zone
  network_id     = yandex_vpc_network.cloudvpc.id
  v4_cidr_blocks = var.public_cidr
}



