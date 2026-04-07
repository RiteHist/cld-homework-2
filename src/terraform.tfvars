subnet_params = [{
    name = "public"
    cidr = ["192.168.10.0/24"]
},
{
    name = "private"
    cidr = ["192.168.20.0/24"]
}]

vm_metadata = {
  "serial-port-enable" = "1"
}

vm_params = {
    "nat_vm" = {
        name = "nat_vm"
        image_id = "fd80mrhj8fl2oe87o4e1"
        cores = 2
        memory = 1
        core_fraction = 20
        preemptible = true
        platform_id = "standard-v4a"
        disk_volume = 10
        ip_address = "192.168.10.254"
        nat = true
    }
    "public_vm" = {
        name = "public_vm"
        image_family = "ubuntu-2004-lts"
        cores = 2
        memory = 1
        core_fraction = 20
        preemptible = true
        platform_id = "standard-v4a"
        nat = true
        disk_volume = 10
    }
    "private_vm" = {
        name = "private_vm"
        image_family = "ubuntu-2004-lts"
        cores = 2
        memory = 1
        core_fraction = 20
        preemptible = true
        platform_id = "standard-v4a"
        nat = false
        disk_volume = 10
    }
}

vm_username = "ritehist"