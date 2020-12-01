/*
win.increment.pkr.hcl: Used to run scripts on Windows. Requires a variable to be set

Example usage: `packer build -var-file="./win10/<increment>.pkrvars.hcl" -only=virtualbox* ./win.increment.pkr.hcl`
- Please note that quotations around the -var-file value seem to be required on Windows

Required vars:
- scripts - list of paths to scripts to run
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

  http_directory = "./shared-files"
}
build {
  sources = [
    "source.virtualbox-ovf.windows"
  ]
  provisioner "powershell" {
      scripts = var.scripts
      environment_vars = [
      "MACHINE_USER_PASSWORD=${var.winrm_password}",
      "MACHINE_USERNAME=${var.winrm_username}",
      "MACHINE_NAME=${var.vm_name}"
    ]
  }
  post-processor "checksum" {
    checksum_types = ["sha256"]
    output = "${local.output_directory}/${var.vm_name}.checksum"
  }
}




variables {
  winrm_password = "vagrant"
  winrm_username = "vagrant"
  script_dir = "./shared-files/windows/scripts/"
  vm_name = "export"
  prev_path = ""
  prev_checksum = ""
  scripts = ["./shared-files/windows/scripts/noop.ps1"]
}
locals {
  output_directory = "./builds/${var.vm_name}"
}