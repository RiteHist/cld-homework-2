data "template_file" "cloud-config-lamp" {
    template = file("${path.module}/cloud-init.tftpl")
    vars = {
        vm_username = var.vm_username
        ssh_pub_keys = local.ssh_pub_key
        lamp = true
        bucket = yandex_storage_bucket.bucket.id
        image_filename = yandex_storage_object.picture.key
    }
}

resource "yandex_iam_service_account" "lamp-sa" {
    name = "lamp_sa"
}

resource "yandex_iam_service_account_iam_binding" "lamp-sa-editor" {
    service_account_id = yandex_iam_service_account.lamp-sa.id
    role = "compute.editor"
    members = [
        "serviceAccount:${yandex_iam_service_account.lamp-sa.id}"
    ]
}

resource "yandex_compute_instance_group" "lamp-group" {
    name = "best-group"
    service_account_id = yandex_iam_service_account.lamp-sa.id
    deletion_protection = false
    instance_template {
        platform_id = "standart-v1"
        resources {
            memory = 2
            cores = 2
        }
        boot_disk {
            initialize_params {
                image_id = "fd827b91d99psvq5fjit"
                size = var.vm_params["nat_vm"].disk_volume
            }
        }
        network_interface {
            
        
        }
    }
}