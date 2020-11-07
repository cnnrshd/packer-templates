#!/bin/bash
packer build -var-file="./win10/base.pkrvars.hcl" -only=virtualbox* ./build.pkr.hcl