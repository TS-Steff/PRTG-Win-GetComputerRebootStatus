# PRTG-GetComputerRebootStatus
 Check if there is a reboot pending
 
# Install
copy `ts.CeckRebootState.ovl` to `"C:\Program Files (x86)\PRTG Network Monitor\lookups"` on your PRTG Server
copy `TS-CheckRebootState.vbs` to  `"C:\Program Files (x86)\PRTG Network Monitor\Custom Sensors\EXEXML"` on your Probe

# config PRTG
Add Script/EXE sensor
pass parameters: `%device %windowsuser %windowsdomain %windowspassword`
**parameters have to be in the order as written above**
