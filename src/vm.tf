data "yandex_compute_image" "image" {
    family = var.vm_params["public_vm"].image_family
}

data "template_file" "cloud-config-normal" {
    template = file("${path.module}/cloud-init.tftpl")
    vars = {
        vm_username = var.vm_username
        ssh_pub_keys = local.ssh_pub_key
        lamp = false
        bucket_name = ""
        image_filename = ""
    }
}

resource "yandex_compute_instance" "nat_vm" {
    name = var.vm_params["nat_vm"].name
    platform_id = var.vm_params["nat_vm"].platform_id
    resources {
        cores = var.vm_params["nat_vm"].cores
        memory = var.vm_params["nat_vm"].memory
        core_fraction = var.vm_params["nat_vm"].core_fraction
    }
    boot_disk {
        initialize_params {
            image_id = var.vm_params["nat_vm"].image_id
            size = var.vm_params["nat_vm"].disk_volume
        }
    }
    network_interface {
        subnet_id = yandex_vpc_subnet.public_subnet.id
        ip_address = var.vm_params["nat_vm"].ip_address
        nat = var.vm_params["nat_vm"].nat
    }
    scheduling_policy {
        preemptible = var.vm_params["nat_vm"].preemptible
    }
    metadata = local.vm_metadata_combined
}

resource "yandex_compute_instance" "public_vm" {
    name = var.vm_params["public_vm"].name
    platform_id = var.vm_params["public_vm"].platform_id
    resources {
        cores = var.vm_params["public_vm"].cores
        memory = var.vm_params["public_vm"].memory
        core_fraction = var.vm_params["public_vm"].core_fraction
    }
    boot_disk {
        initialize_params {
            image_id = data.yandex_compute_image.image.image_id
            size = var.vm_params["public_vm"].disk_volume
        }
    }
    network_interface {
        subnet_id = yandex_vpc_subnet.public_subnet.id
        nat = var.vm_params["public_vm"].nat
    }
    scheduling_policy {
        preemptible = var.vm_params["public_vm"].preemptible
    }
    metadata = local.vm_metadata_combined
}

resource "yandex_compute_instance" "private_vm" {
    name = var.vm_params["private_vm"].name
    platform_id = var.vm_params["private_vm"].platform_id
    resources {
        cores = var.vm_params["private_vm"].cores
        memory = var.vm_params["private_vm"].memory
        core_fraction = var.vm_params["private_vm"].core_fraction
    }
    boot_disk {
        initialize_params {
            image_id = data.yandex_compute_image.image.image_id
            size = var.vm_params["private_vm"].disk_volume
        }
    }
    network_interface {
        subnet_id = yandex_vpc_subnet.private_subnet.id
        nat = var.vm_params["private_vm"].nat
    }
    scheduling_policy {
        preemptible = var.vm_params["private_vm"].preemptible
    }
    metadata = local.vm_metadata_combined
}