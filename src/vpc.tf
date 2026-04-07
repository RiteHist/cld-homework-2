resource "yandex_vpc_network" "vpc" {
    name = var.vpc_name
}

resource "yandex_vpc_subnet" "public_subnet" {
    name = var.subnet_params[0].name
    zone = var.default_zone
    network_id = yandex_vpc_network.vpc.id
    v4_cidr_blocks = var.subnet_params[0].cidr
}

resource "yandex_vpc_subnet" "private_subnet" {
    name = var.subnet_params[1].name
    zone = var.default_zone
    network_id = yandex_vpc_network.vpc.id
    v4_cidr_blocks = var.subnet_params[1].cidr
    route_table_id = yandex_vpc_route_table.rt-nat.id
}