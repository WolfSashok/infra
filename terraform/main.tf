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
    tags = ["reddit-app"]
    # определение загрузочного диска
    boot_disk {
        initialize_params {
        image = "debian-11-bullseye-v20221206"
        }
    }

    connection {
        type = "ssh"
        user = "wolfsashok85"
        agent = false
        # путь до приватного ключа
        private_key = "${file("~/.ssh/id_rsa")}"
    }

    provisioner "file" {
        source = "files/puma.service"
        destination = "/tmp/puma.service"
    }

    provisioner "remote-exec" {
        script = "files/deploy.sh"
    }

    # определение сетевого интерфейса
    network_interface {
        # сеть, к которой присоединить данный интерфейс
        network = "default"
        # использовать ephemeral IP для доступа из Интернет
        access_config {}
    }
}

resource "google_compute_firewall" "firewall_puma" {
    name = "allow-puma-default"
    # Название сети, в которой действует правило
    network = "default"
    # Какой доступ разрешить
    allow {
        protocol = "tcp"
        ports = ["9292"]
    }
    # Каким адресам разрешаем доступ
    source_ranges = ["0.0.0.0/0"]
    # Правило применимо для инстансов с перечисленными тэгами
    target_tags = ["reddit-app"]
}
