terraform {
    # Версия terraform
    required_version = "1.3.6"
}


provider "google" {
    # Версия провайдера
    #version = "2.0.0"

    # ID проекта
    project = "original-list-372101"

    region = "europe-west-1"
}
