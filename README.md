# packer-templates
This repository is HCL-based Packer templates (and related scripts/files) for building Windows images.
## Current features
* Two Windows versions (Windows 10 and Server 2019)
* Working code 
* Increment/onion-based templating
* Basic build scripts
## What you need
* Packer (single binary, drop in your path)
  * https://www.packer.io/downloads
* Windows Update provisioner (drop in the same folder as Packer binary)
  * https://github.com/rgl/packer-provisioner-windows-update
* Download and drop the virtio-iso into the `iso` folder
  * Direct download: https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso
## Other resources
* https://github.com/StefanScherer/packer-windows
  * Fantastic repo, what I used for starting out, has a ton of useful scripts/answer files
* https://www.windowsafg.com/
  * Answer file generator, used for generating answer files