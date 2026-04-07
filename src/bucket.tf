resource "yandex_storage_bucket" "bucket" {
    bucket_prefix = var.bucket_params[0].prefix
    anonymous_access_flags {
        config_read = var.bucket_params[0].access_config
        list = var.bucket_params[0].access_list
        read = var.bucket_params[0].access_read
    }
}

resource "yandex_storage_object" "picture" {
    bucket = yandex_storage_bucket.bucket.id
    key = var.static_image_params["key"]
    source = "${path.module}/../${var.static_image_params["path"]}"
}