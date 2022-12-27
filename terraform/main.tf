terraform {
    # Версия terraform
    required_version = "1.3.6"
}
#VSC installed

provider "google" {
    # Версия провайдера
    #version = "2.0.0"
    credentials = file(".terraform/mygcp-creds.json")
    # ID проекта
    project = "original-list-372101"

    region = "europe-west4-a"
}

resource "google_compute_instance" "app" {
    name = "reddit-app"
    machine_type = "e2-micro"
    zone = "europe-west4-a"
    # определение загрузочного диска
    boot_disk {
        initialize_params {
        image = "debian-11-bullseye-v20221206"
        }
    }
    # определение сетевого интерфейса
    network_interface {
        # сеть, к которой присоединить данный интерфейс
        network = "default"
        # использовать ephemeral IP для доступа из Интернет
        access_config {}
    }
}