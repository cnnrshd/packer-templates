# Grab unattend
# Template unattend
$uri = "http://" + $Env:PACKER_HTTP_ADDR + "/windows/files/unattend.xml"
write-host $uri
Invoke-WebRequest -UseBasicParsing -Uri $uri -OutFile "C:\unattend.xml"
c:\windows\system32\sysprep\sysprep.exe /generalize /shutdown /quiet /unattend:C:\unattend.xml