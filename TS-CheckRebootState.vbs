'https://www.winvistatips.com/threads/how-can-i-write-a-script-to-read-a-remote-registry-using-different-credentials.760483/
'#####
' 0 - OK, no reboot pending
' 1 - Reboot pending
' 2 - Wrong argument count
' 3 - Connection Error

On Error Resume Next
Err.Clear

Const HKCR = &H80000000 'HKEY_CLASSES_ROOT
Const HKCU = &H80000001 'HKEY_CURRENT_USER
Const HKLM = &H80000002 'HKEY_LOCAL_MACHINE
Const HKUS = &H80000003 'HKEY_USERS
Const HKCC = &H80000005 'HKEY_CURRENT_CONFIG


Dim strComputer, strUser, strPassword
Dim objSWbemLocator, objSWbemServices, objReg
Dim strKeyPath, strEntryName, strValue
Dim rebootReuired

Set objArguments = WScript.Arguments
'arguments
'https://www.clearbyte.ch/vb-script-parameter-uebergabe/

rebootRequired = 0
strComputer = ""
strUser = ""
strDomain = ""
strPassword = ""
strDomainUser = ""
strKeyPathWUPD = "SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired"
strKeyPathCBS = "SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending"


'check argument count
if objArguments.Count <> 4 Then
	WScript.echo "2:Wrong argument Count"
	WScript.Quit
else
	strComputer = objArguments(0)
	strUser = objArguments(1)
	strDomain = objArguments(2)
	strPassword = objArguments(3)
	strDomainUser = strDomain & "\" & strUser
end if


'connect to server
Set objSWbemLocator = CreateObject("wbemScripting.SwbemLocator")
Set objSWbemServices = objSWbemLocator.ConnectServer(strComputer, "root\default", strDomainUser, strPassword)

if Err.Number <> 0 Then
	WScript.echo "3:" & Err.Description
	WScript.Quit
end if

Set objReg = objSWbemServices.Get("StdRegProv")
if Err.Number <> 0 Then
	WScript.echo "3:" & Err.Description
	WScript.Quit
end if

'check if WUPD or CBS reboot flagged
if objReg.EnumKey(HKLM, strKeyPathWUPD, arrSubKeys) = 0 OR objReg.EnumKey(HKLM, strKeyPathCBS, arrSubKeys) = 0  Then
  '*** Reboot Required ***
  WScript.echo "1:Reboot Pending"
else
  '*** NO REBOOT REQUIRED
  WScript.echo "0:OK"
end if



