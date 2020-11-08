#!/bin/bash
packer build -var-file="./win10/install.pkrvars.hcl" -only=virtualbox* ./win.install.pkr.hcl
packer build -var-file="./win10/update.pkrvars.hcl" -only=virtualbox* ./win.update.pkr.hcl
packer build -var-file="./win10/install-ghidra.pkrvars.hcl" -only=virtualbox* ./win.increment.pkr.hcl
packer build -var-file="./win10/export.pkrvars.hcl" -only=virtualbox* ./win.export.pkr.hcl