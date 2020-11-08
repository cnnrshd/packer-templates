/*
win.build.pkr.hcl: Used to install Windows. Requires several variables to be set. Suggested to run with the -only flag set, QEMU and Virtualbox tend to be incompatible.

Example usage: `packer build -var-file="./win10/install.pkrvars.hcl" -only=virtualbox* ./win.install.pkr.hcl`
- Please note that quotations around the -var-file value seem to be required on Windows

Required vars:
- autounattend
- vm_name
- iso_url
- iso_checksum
- guest_os_type
*/
source "qemu" "windows" {
  floppy_files = local.floppies
  vm_name = var.vm_name
  accelerator = "kvm"
  boot_wait = "30s"
  headless = false
  qemuargs = [
		[ "-cdrom", "./iso/virtio-win.iso" ],
  ]
  
  iso_url = var.iso_url
  iso_checksum = var.iso_checksum

  disk_size = var.str_disk_size
  cpus = var.cpus
  memory = var.memory
  net_device = "virtio-net"
  disk_interface = "virtio"
  format = "qcow2"

  winrm_username = var.winrm_username
  winrm_password = var.winrm_password
  communicator = "winrm"
  winrm_timeout = "60m"
  shutdown_command = "shutdown /s /t 10 /f /d p:4:1 /c \"Packer Shutdown\""
	output_directory = local.output_directory
}

source "virtualbox-iso" "windows" {
  floppy_files = local.floppies
  vm_name = var.vm_name
  boot_wait = "30s"
  headless = false
  guest_os_type = var.guest_os_type
  guest_additions_mode = "disable"
  
  iso_url = var.iso_url
  iso_checksum = var.iso_checksum

  disk_size = var.uint_disk_size
  cpus = var.cpus
  memory = var.memory

  winrm_username = var.winrm_username
  winrm_password = var.winrm_password
  communicator = "winrm"
  winrm_timeout = "60m"
  shutdown_command = "shutdown /s /t 10 /f /d p:4:1 /c \"Packer Shutdown\""
	output_directory = local.output_directory
}

build {
  sources = [
    "source.qemu.windows",
    "source.virtualbox-iso.windows"
  ]
  provisioner "windows-shell" {
    inline = ["shutdown /s /t 10 /f /d p:4:1 /c \"Packer Shutdown\""]
  }
  post-processor "checksum" {
    checksum_types = ["sha256"]
    output = "${local.output_directory}/${var.vm_name}.checksum"
  }
}

/*
Vars have to be declared in a .pkr file, a .pkrvar file is used to assign
values to variables that have already been declared. To minimize duplicate
code, this section is needed.
*/
variables {
  memory = 4096
  cpus = 2
  # Disk size for QEMU is string, for Virtualbox it's UINT.
  uint_disk_size = 25000
  str_disk_size = "25G"
  iso_url = ""
  iso_checksum = ""
  autounattend = ""
  winrm_password = "vagrant"
  winrm_username = "vagrant"
  script_dir = "./shared-files/windows/scripts/"
  vm_name = ""
  guest_os_type = ""
}

locals {
  floppies = [
    "${var.autounattend}",
    "${var.script_dir}disable-winrm.ps1",
    "${var.script_dir}fixnetwork.ps1",
    "${var.script_dir}enable-winrm.ps1",
    "${var.script_dir}configure-remoting-for-ansible.ps1"
  ]
  output_directory = "./builds/${var.vm_name}"
}