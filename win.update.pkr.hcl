/*
win.install.pkr.hcl: Used to install Windows. Requires several variables to be set. Suggested to run with the -only flag set, QEMU and Virtualbox tend to be incompatible.

Example usage: `packer build -var-file="./win10/install.pkrvars.hcl" -only=virtualbox* ./install.pkr.hcl`
- Please note that quotations around the -var-file value seem to be required on Windows

Required vars:

vm_name
prev_path
prev_checksum
*/

source "virtualbox-ovf" "windows" {
  vm_name = var.vm_name
  boot_wait = "30s"
  headless = false
  guest_additions_mode = "disable"

  source_path = var.prev_path
  checksum = var.prev_checksum

  winrm_username = var.winrm_username
  winrm_password = var.winrm_password
  communicator = "winrm"
  winrm_timeout = "60m"
  shutdown_command = "shutdown /s /t 10 /f /d p:4:1 /c \"Packer Shutdown\""
	output_directory = local.output_directory
}

build {
  sources = [
    # "source.qemu.windows",
    "source.virtualbox-ovf.windows"
  ]
  provisioner "windows-update" {
      search_criteria = var.search_criteria
      update_limit = var.update_limit
      filters = var.update_filters
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
  winrm_password = "vagrant"
  winrm_username = "vagrant"
  script_dir = "./shared-files/windows/scripts/"
  vm_name = ""
  prev_path = ""
  prev_checksum = ""
  search_criteria = "AutoSelectOnWebSites=1 and IsInstalled=0"
  update_limit = 1000
  update_filters = ["exclude:$_.Title -like '*Language*'", "include:$true"]
}

locals {
  output_directory = "./builds/${var.vm_name}"
}