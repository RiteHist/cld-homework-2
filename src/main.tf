terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = "~>1.9.1"
  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
      dynamodb = "https://docapi.serverless.yandexcloud.net/ru-central1/b1gfju9irjmi29ag2kvk/etnpa1j6nq5dq7s5ufs7"
    }
    bucket = "tfstate-good"
    region = "ru-central1"
    key = "terraform.tfstate"

    skip_region_validation = true
    skip_credentials_validation = true
    skip_requesting_account_id = true
    skip_s3_checksum = true
    
    dynamodb_table = "tfstate-good"
  }
}

provider "yandex" {
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.default_zone
  service_account_key_file = file("~/.authorized_key.json")
}