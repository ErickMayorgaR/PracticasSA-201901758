locals {
    project_id       = "sa-201901758"
    network          = "default"
    image            = "ubuntu-2004-focal-v20211212"
    ssh_user         = "ansible"
    private_key      = file("C:/Users/Erick/.ssh/ansbile_ed25519")

}

provider "google" {
    project = local.project_id
    region = "us-central1"
}

resource "google_service_account" "sa" {
    account_id   = "sa-201901758"
}


resource "google_compute_firewall" "web"{
    name = "web-access"
    network = local.network

    allow {
        protocol = "tcp"
        ports = ["80"]
    
    }

    source_ranges = ["0.0.0.0/0"]
    target_service_accounts = [google_service_account.sa.email]

}


resource "google_compute_address" "prod_vm_ip_f" {
  name   = "prod-vm-ip-f"
  region = "us-central1"
}


resource "google_compute_instance" "prod-vm" {
    name         = "prod-vm-f"
    machine_type = "e2-micro"
    zone         = "us-central1-a"
     tags        = ["http-server", "https-server", "web-access"] 

    boot_disk {
        initialize_params {
            image = local.image
        }
    }

    network_interface {
        network = local.network
        access_config {
        nat_ip = google_compute_address.prod_vm_ip_f.address
        }
    }


    provisioner "remote-exec" {
    // Conectarse a través de SSH para configurar la VM de producción
    connection {
      type        = "ssh"
      host        = self.network_interface[0].access_config[0].nat_ip
      user        = "ansible"
      private_key = local.private_key
    }

    inline = [
      "sudo adduser ansible --gecos '' --disabled-password",
      "echo 'ansible:ansible' | sudo chpasswd",
      "echo 'ansible ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/ansible",
      "sudo sed -i 's/^#PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config",
      "sudo systemctl restart sshd"
    ]
  }
}



resource "google_compute_instance" "ansible" {
    name         = "ansible-vm"
    machine_type = "e2-micro"
    zone         = "us-central1-a"

    boot_disk {
        initialize_params {
            image = local.image
        }
    }

    network_interface {
        network = local.network
        access_config {
        }
    }


     provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = self.network_interface[0].access_config[0].nat_ip
      user        = "ansible"
      private_key  = local.private_key

    }

    inline = [
      "sudo apt update",
      "sudo apt install software-properties-common -y",
      "sudo add-apt-repository --yes --update ppa:ansible/ansible",
      "sudo apt install ansible -y",
    ]
  }
}



