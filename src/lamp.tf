data "template_file" "cloud-config-lamp" {
    template = file("${path.module}/cloud-init.tftpl")
    vars = {
        vm_username = var.vm_username
        ssh_pub_keys = local.ssh_pub_key
        lamp = true
        bucket_name = yandex_storage_bucket.bucket.id
        image_filename = yandex_storage_object.picture.key
    }
}

resource "yandex_iam_service_account" "lamp-sa" {
    name = var.compute_group_params["lamp"].sa_name
}

resource "yandex_resourcemanager_folder_iam_member" "lamp-sa-editor" {
    folder_id = var.folder_id
    role = "editor"
    member = "serviceAccount:${yandex_iam_service_account.lamp-sa.id}"
}

resource "yandex_compute_instance_group" "lamp-group" {
    name = var.vm_params["lamp"].name
    service_account_id = "${yandex_iam_service_account.lamp-sa.id}"
    deletion_protection = var.compute_group_params["lamp"].deletion_protection
    instance_template {
        platform_id = var.vm_params["lamp"].platform_id
        resources {
            memory = var.vm_params["lamp"].memory
            cores = var.vm_params["lamp"].cores
            core_fraction = var.vm_params["lamp"].core_fraction
        }
        boot_disk {
            initialize_params {
                image_id = var.vm_params["lamp"].image_id
                size = var.vm_params["lamp"].disk_volume
            }
        }
        network_interface {
            network_id = yandex_vpc_network.vpc.id
            subnet_ids = ["${yandex_vpc_subnet.public_subnet.id}"]
            nat = var.vm_params["lamp"].nat
        }
        metadata = local.lamp_metadata_combined
    }
    scale_policy {
        fixed_scale {
            size = var.compute_group_params["lamp"].scale_size
        }
    }
    allocation_policy {
        zones = ["${var.default_zone}"]
    }
    deploy_policy {
        max_expansion = var.compute_group_params["lamp"].max_expansion
        max_unavailable = var.compute_group_params["lamp"].max_unavailable
    }
    health_check {
        interval = var.compute_group_params["lamp"].health_interval
        timeout = var.compute_group_params["lamp"].health_timeout
        unhealthy_threshold = var.compute_group_params["lamp"].unhealthy_threshold
        http_options {
            path = var.compute_group_params["lamp"].http_path
            port = var.compute_group_params["lamp"].http_port
        }
    }
    load_balancer {
        target_group_name = var.compute_group_params["lamp"].lbtarget_name
    }
    depends_on = [ yandex_resourcemanager_folder_iam_member.lamp-sa-editor ]
}

resource "yandex_lb_network_load_balancer" "lb" {
    name = var.load_balancer_params[0].name

    listener {
        name = var.load_balancer_params[0].listener_name
        port = var.load_balancer_params[0].port
        external_address_spec {
            ip_version = var.load_balancer_params[0].ip_version
        }
    }
    attached_target_group {
        target_group_id = yandex_compute_instance_group.lamp-group.load_balancer.0.target_group_id
        healthcheck {
            name = var.load_balancer_params[0].healthcheck_name
            http_options {
                port = var.compute_group_params["lamp"].http_port
                path = var.compute_group_params["lamp"].http_path
            }
        }
    }
}