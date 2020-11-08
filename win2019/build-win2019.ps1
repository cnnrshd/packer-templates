#!/bin/bash
packer build -var-file="./win2019/install.pkrvars.hcl" -only=virtualbox* ./win.install.pkr.hcl
packer build -var-file="./win2019/update.pkrvars.hcl" -only=virtualbox* ./win.update.pkr.hcl
packer build -var-file="./win2019/install-chocolatey.pkrvars.hcl" -only=virtualbox* ./win.increment.pkr.hcl
#packer build -var-file="./win2019/export.pkrvars.hcl" -only=virtualbox* ./win.export.pkr.hcl