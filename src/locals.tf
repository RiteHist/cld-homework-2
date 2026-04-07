locals {
    ssh_pub_key = file(var.ssh_key_path)
    vm_metadata_combined = merge(var.vm_metadata, {"user-data" = "${data.template_file.cloud-config-normal.rendered}"})
    lamp_metadata_combined = merge(var.vm_metadata, {"user-data" = "${data.template_file.cloud-config-lamp.rendered}"})
}