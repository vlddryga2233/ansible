terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.83.0"
    }
  }
}

provider "google" {
  project     = var.project
  region      = var.region
  zone        = var.zone
  credentials = var.credentials
}

resource "google_service_account" "default" {
  account_id   = "service-account-id"
  display_name = "Service Account"
}

data "google_compute_image" "default" {
  family  = "windows-2016"
  project = "windows-cloud"
}
data "google_compute_image" "linux" {
  family  = "ubuntu-2004-lts"
  project = "ubuntu-os-cloud"
}

resource "google_compute_instance" "default1" {
  name         = "nginx-lb"
  machine_type = "e2-medium"
  zone         = var.zone

  tags = ["allow-http"]
  boot_disk {
    initialize_params {
      image = data.google_compute_image.linux.self_link
    }
  }

  network_interface {
    network = "default"
    access_config {

    }
  }

  provisioner "remote-exec" {
    inline = ["echo 'Hello world!'"]
    connection {
      type        = "ssh"
      host        = self.network_interface.0.access_config.0.nat_ip
      user        = "ansible"
      private_key = file(var.ssh_key_private)
    }
  }
  provisioner "local-exec" {
    command = "ansible -i '${self.network_interface.0.access_config.0.nat_ip}' -m ping"
  }
  service_account {
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }
}
/*resource "google_compute_instance" "default2" {
  name         = "linux-webserver"
  machine_type = "e2-medium"
  zone         = var.zone

  tags = ["allow-http"]

  boot_disk {
    initialize_params {
      image = data.google_compute_image.linux.self_link
    }
  }

  network_interface {
    network = "default"
    access_config {

    }
  }
  service_account {
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }
}
resource "google_compute_instance" "default" {
  name         = "windows-webserver"
  machine_type = "e2-medium"
  zone         = var.zone

  tags = ["allow-http"]

  boot_disk {
    initialize_params {
      image = data.google_compute_image.default.self_link
    }
  }

  network_interface {
    network = "default"
    access_config {

    }
  }
  service_account {
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }
}*/
