
resource "yandex_resourcemanager_folder_iam_member" "editor" {
  folder_id = var.folder_id
  role       = "editor"
  member     = "serviceAccount:${yandex_iam_service_account.sa.id}"
  depends_on = [
    yandex_iam_service_account.sa
  ]
}

resource "yandex_compute_instance_group" "ig-1" {
  name                = "ig1"
  folder_id           = var.folder_id
  service_account_id  = "${yandex_iam_service_account.sa.id}"
  deletion_protection = false
  depends_on          = [yandex_resourcemanager_folder_iam_member.editor]
  instance_template {
    platform_id = "standard-v1"
    resources {
      cores         = var.vm_resources.core
      memory        = var.vm_resources.memory
      core_fraction = var.vm_resources.core_fraction
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "fd827b91d99psvq5fjit"
      }
    }
    scheduling_policy {
      preemptible = var.vm_premtible
    }
    network_interface {
      network_id = "${yandex_vpc_network.cloudvpc.id}"
      subnet_ids = ["${yandex_vpc_subnet.devnet.id}"]
      nat        = var.vm_nat
    }

    metadata = {
      serial-port-enable = var.metadata.serial-port-enable
      ssh-keys           = "ubuntu:${var.metadata.ssh-keys}"
      user-data = "#cloud-config\nruncmd:\n - echo '<html><h1>TestWEB01</h1></html>' > /var/www/html/index.html"
   }
  }

  scale_policy {
    fixed_scale {
      size = 2
    }
  }

  allocation_policy {
    zones = ["ru-central1-a"]
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }
}

