# === [Ubuntu 24 Deployer VM] ===
resource "proxmox_virtual_environment_vm" "dev_ubuntu24_deployer" {
  node_name = "furina"
  vm_id     = 3030
  name      = "dev-ubuntu24-deployer"

  clone {
    vm_id        = 99994 # template ubuntu24
    datastore_id = "nvme-zfs"
    full         = true
  }

  agent { enabled = true }

  cpu {
    cores = 2
    type  = "host"
  }

  memory { dedicated = 4096 }

  disk {
    datastore_id = "nvme-zfs"
    interface    = "scsi0"
    size         = 30
    discard      = "on"
    ssd          = true
  }

  network_device { bridge = "vmbr0" } # management

  serial_device { device = "socket" }
  vga { type = "serial0" }

  initialization {
    datastore_id = "nvme-zfs"

    ip_config { # management
      ipv4 {
        address = "192.168.19.30/24"
        gateway = "192.168.19.1"
      }
    }

    user_account {
      username = "rizwan"
      keys     = [var.ssh_proxmox_key]
    }
  }

  on_boot = true
}

# === [Synology Central Storage VM] ===
resource "proxmox_virtual_environment_vm" "dev_synology_central_storage" {
  node_name = "furina"
  vm_id     = 3031
  name      = "dev-synology-central-storage"

  bios          = "seabios"
  scsi_hardware = "virtio-scsi-pci"
  boot_order    = ["sata0"]

  operating_system { type = "l26" }

  agent { enabled = false }

  cpu {
    cores   = 4
    sockets = 1
    type    = "host"
    numa    = false
  }

  memory {
    dedicated = 8192
    floating  = 512
  }

  # boot disk (loader synology-v4.0.5.img)
  disk {
    datastore_id = "nvme-zfs"
    file_id      = "iso-template:iso/synology-v4.0.5.img"
    interface    = "sata0"
    size         = 50
  }

  # data disk 4x 150gb
  disk {
    datastore_id = "nvme-zfs"
    interface    = "sata1"
    size         = 150
    ssd          = true
  }
  disk {
    datastore_id = "nvme-zfs"
    interface    = "sata2"
    size         = 150
    ssd          = true
  }
  disk {
    datastore_id = "nvme-zfs"
    interface    = "sata3"
    size         = 150
    ssd          = true
  }
  disk {
    datastore_id = "nvme-zfs"
    interface    = "sata4"
    size         = 150
    ssd          = true
  }

  network_device { bridge = "vmbr0" }   # management
  network_device { bridge = "stgopn1" } # storage01
  network_device { bridge = "stgopn2" } # storage02

  lifecycle {
    ignore_changes = [disk]
  }
}

# === [OpenStack Controller 01] ===
resource "proxmox_virtual_environment_vm" "dev_openstack_controller_01" {
  node_name = "furina"
  vm_id     = 3036
  name      = "dev-openstack-controller-01"

  clone {
    vm_id        = 99994 # template ubuntu24
    datastore_id = "nvme-zfs"
    full         = true
  }

  agent { enabled = true }

  cpu {
    cores = 4
    type  = "host"
  }

  memory { dedicated = 8192 }

  disk {
    datastore_id = "nvme-zfs"
    interface    = "scsi0"
    size         = 128
    discard      = "on"
    ssd          = true
  }

  network_device { bridge = "vmbr0" }      # management
  network_device { bridge = "intopnstck" } # internal openstack 
  network_device { bridge = "stgopn1" }    # storage01
  network_device { bridge = "stgopn2" }    # storage02
  network_device { bridge = "vmbr0" }      # external provider

  serial_device { device = "socket" }
  vga { type = "serial0" }

  initialization {
    datastore_id = "nvme-zfs"

    ip_config { # management
      ipv4 {
        address = "192.168.19.36/24"
        gateway = "192.168.19.1"
      }
    }
    ip_config { # internal openstack
      ipv4 { address = "172.16.1.36/24" }
    }
    ip_config { # storage01
      ipv4 { address = "172.16.2.36/24" }
    }
    ip_config { # storage02
      ipv4 { address = "172.16.3.36/24" }
    }
    ip_config {} # external provider

    user_account {
      username = "rizwan"
      keys     = [var.ssh_proxmox_key]
    }
  }

  on_boot = true
}

# === [OpenStack Controller 02] ===
resource "proxmox_virtual_environment_vm" "dev_openstack_controller_02" {
  node_name = "furina"
  vm_id     = 3037
  name      = "dev-openstack-controller-02"

  clone {
    vm_id        = 99994 # template ubuntu24
    datastore_id = "nvme-zfs"
    full         = true
  }

  agent { enabled = true }

  cpu {
    cores = 4
    type  = "host"
  }

  memory { dedicated = 8192 }

  disk {
    datastore_id = "nvme-zfs"
    interface    = "scsi0"
    size         = 128
    discard      = "on"
    ssd          = true
  }

  network_device { bridge = "vmbr0" }      # management
  network_device { bridge = "intopnstck" } # internal openstack
  network_device { bridge = "stgopn1" }    # storage01
  network_device { bridge = "stgopn2" }    # storage02
  network_device { bridge = "vmbr0" }      # external provider

  serial_device { device = "socket" }
  vga { type = "serial0" }

  initialization {
    datastore_id = "nvme-zfs"

    ip_config { # management
      ipv4 {
        address = "192.168.19.37/24"
        gateway = "192.168.19.1"
      }
    }
    ip_config { # internal openstack
      ipv4 { address = "172.16.1.37/24" }
    }
    ip_config { # storage01
      ipv4 { address = "172.16.2.37/24" }
    }
    ip_config { # storage02
      ipv4 { address = "172.16.3.37/24" }
    }
    ip_config {} # external provider

    user_account {
      username = "rizwan"
      keys     = [var.ssh_proxmox_key]
    }
  }

  on_boot = true
}

# === [OpenStack Controller 03] ===
resource "proxmox_virtual_environment_vm" "dev_openstack_controller_03" {
  node_name = "furina"
  vm_id     = 3038
  name      = "dev-openstack-controller-03"

  clone {
    vm_id        = 99994 # template ubuntu24
    datastore_id = "nvme-zfs"
    full         = true
  }

  agent { enabled = true }

  cpu {
    cores = 4
    type  = "host"
  }

  memory { dedicated = 8192 }

  disk {
    datastore_id = "nvme-zfs"
    interface    = "scsi0"
    size         = 128
    discard      = "on"
    ssd          = true
  }

  network_device { bridge = "vmbr0" }      # management
  network_device { bridge = "intopnstck" } # internal openstack
  network_device { bridge = "stgopn1" }    # storage01
  network_device { bridge = "stgopn2" }    # storage02
  network_device { bridge = "vmbr0" }      # external provider

  serial_device { device = "socket" }
  vga { type = "serial0" }

  initialization {
    datastore_id = "nvme-zfs"

    ip_config { # management
      ipv4 {
        address = "192.168.19.38/24"
        gateway = "192.168.19.1"
      }
    }
    ip_config { # internal openstack
      ipv4 { address = "172.16.1.38/24" }
    }
    ip_config { # storage01
      ipv4 { address = "172.16.2.38/24" }
    }
    ip_config { # storage02
      ipv4 { address = "172.16.3.38/24" }
    }
    ip_config {} # external provider

    user_account {
      username = "rizwan"
      keys     = [var.ssh_proxmox_key]
    }
  }

  on_boot = true
}

# === [OpenStack Compute 01] ===
resource "proxmox_virtual_environment_vm" "dev_openstack_compute_01" {
  node_name = "furina"
  vm_id     = 3041
  name      = "dev-openstack-compute-01"

  clone {
    vm_id        = 99994 # template ubuntu24
    datastore_id = "nvme-zfs"
    full         = true
  }

  agent { enabled = true }

  cpu {
    cores = 8
    type  = "host"
  }

  memory { dedicated = 16384 }

  disk {
    datastore_id = "nvme-zfs"
    interface    = "scsi0"
    size         = 128
    discard      = "on"
    ssd          = true
  }

  network_device { bridge = "vmbr0" }      # management
  network_device { bridge = "intopnstck" } # internal openstack
  network_device { bridge = "stgopn1" }    # storage01
  network_device { bridge = "stgopn2" }    # storage02
  network_device { bridge = "vmbr0" }      # external provider

  serial_device { device = "socket" }
  vga { type = "serial0" }

  initialization {
    datastore_id = "nvme-zfs"

    ip_config { # management
      ipv4 {
        address = "192.168.19.41/24"
        gateway = "192.168.19.1"
      }
    }
    ip_config { # internal openstack
      ipv4 { address = "172.16.1.41/24" }
    }
    ip_config { # storage01
      ipv4 { address = "172.16.2.41/24" }
    }
    ip_config { # storage02
      ipv4 { address = "172.16.3.41/24" }
    }
    ip_config {} # external provider

    user_account {
      username = "rizwan"
      keys     = [var.ssh_proxmox_key]
    }
  }

  on_boot = true
}

# === [OpenStack Compute 02] ===
resource "proxmox_virtual_environment_vm" "dev_openstack_compute_02" {
  node_name = "furina"
  vm_id     = 3042
  name      = "dev-openstack-compute-02"

  clone {
    vm_id        = 99994 # template ubuntu24
    datastore_id = "nvme-zfs"
    full         = true
  }

  agent { enabled = true }

  cpu {
    cores = 8
    type  = "host"
  }

  memory { dedicated = 16384 }

  disk {
    datastore_id = "nvme-zfs"
    interface    = "scsi0"
    size         = 128
    discard      = "on"
    ssd          = true
  }

  network_device { bridge = "vmbr0" }      # management
  network_device { bridge = "intopnstck" } # internal openstack
  network_device { bridge = "stgopn1" }    # storage01
  network_device { bridge = "stgopn2" }    # storage02
  network_device { bridge = "vmbr0" }      # external provider

  serial_device { device = "socket" }
  vga { type = "serial0" }

  initialization {
    datastore_id = "nvme-zfs"

    ip_config { # management
      ipv4 {
        address = "192.168.19.42/24"
        gateway = "192.168.19.1"
      }
    }
    ip_config { # internal openstack
      ipv4 { address = "172.16.1.42/24" }
    }
    ip_config { # storage01
      ipv4 { address = "172.16.2.42/24" }
    }
    ip_config { # storage02
      ipv4 { address = "172.16.3.42/24" }
    }
    ip_config {} # external provider

    user_account {
      username = "rizwan"
      keys     = [var.ssh_proxmox_key]
    }
  }

  on_boot = true
}