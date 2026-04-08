variable "default_zone" {
    type = string
    default = "ru-central1-a"
}

variable "cloud_id" {
    type = string
}

variable "folder_id" {
    type = string
}

variable "vpc_name" {
    type = string
    default = "cool_vpc"
}

variable "subnet_params" {
    type = list(object({
        name = string
        cidr = list(string)
    }))
}

variable "ssh_key_path" {
    type = string
    default = "~/.ssh/id_ed25519.pub"
}

variable "vm_metadata" {
    type = map(string)
}

variable "vm_params" {
    type = map(object({
        name = string
        image_family = optional(string)
        image_id = optional(string)
        cores = number
        memory = number
        core_fraction = optional(number)
        preemptible = optional(bool)
        platform_id = string
        nat = bool
        disk_volume = number
        ip_address = optional(string)
    }))
}

variable "vm_username" {
    type = string
}

variable "bucket_params" {
    type = list(object({
        prefix = string
        access_read = bool
        access_list = bool
        access_config = bool
    }))
    default = [{
      access_config = false
      access_list = false
      access_read = true
      prefix = "test"
    }]
}

variable "static_image_params" {
    type = map(string)
    default = {
        "key" = "test_image.png"
        "path" = "media/test_image.png"
    }
}

variable "compute_group_params" {
    type = map(object({
        sa_name = string
        deletion_protection = bool
        scale_size = number
        max_expansion = number
        max_unavailable = number
        health_interval = number
        health_timeout = number
        unhealthy_threshold = number
        http_path = string
        http_port = number
        lbtarget_name = string
    })) 
}

variable "load_balancer_params" {
    type = list(object({
        name = string
        listener_name = string
        port = number
        ip_version = string
        healthcheck_name = string
    }))
}