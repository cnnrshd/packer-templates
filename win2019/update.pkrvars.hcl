// prev_name = ""
vm_name = "win2019-update"
prev_path = "./builds/win2019-test/win2019-test.ovf"
prev_checksum = "./builds/win2019-test/win2019-test.checksum"
# Update-specific vars
search_criteria = "AutoSelectOnWebSites=1 and IsInstalled=0"
update_limit = 25
update_filters = ["exclude:$_.Title -like '*Language*'", "include:$true"]