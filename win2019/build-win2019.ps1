#!/bin/bash
packer build -force -on-error=abort -var-file="./win2019/install.pkrvars.hcl" -only=virtualbox* ./win.install.pkr.hcl
#packer build -on-error=abort -var-file="./win2019/update.pkrvars.hcl" -only=virtualbox* ./win.update.pkr.hcl
#packer build -on-error=abort -var-file="./win2019/install-chocolatey.pkrvars.hcl" -only=virtualbox* ./win.increment.pkr.hcl
packer build -force -on-error=abort -var 'prev_path=./builds/win2019-test/win2019-test.ovf' -var 'prev_checksum=./builds/win2019-test/win2019-test.checksum' -var-file="./win2019/export.pkrvars.hcl" -only=virtualbox* ./win.export.pkr.hcl