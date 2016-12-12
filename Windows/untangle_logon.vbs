'Handle or Ignore all errors
On Error Resume Next

'Time in milliseconds to sleep between request
SLEEP_PERIOD = 300000

URL_PREFIX = "http"

'Get gateway address of client machine
strComputer = "."
Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\CIMV2")
Set colItems = objWMIService.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration Where IPEnabled = True")
For Each objItem In colItems
   'strIPAddress = Join(objItem.IPAddress, ",")
   strDefaultIPGateway = Join(objItem.DefaultIPGateway, ",")
   'MsgBox "IP=" & strIPAddress & vbCrLf & "GW=" & strDefaultIPGateway
Next

ServerName = strDefaultIPGateway
'WScript.Echo ServerName

Do While True
  Set AJAX = CreateObject("MSXML2.ServerXMLHTTP")
  Set wshShell = CreateObject("WScript.Shell")
  strUser = wshShell.ExpandEnvironmentStrings("%USERNAME%")
  strDomain = wshShell.ExpandEnvironmentStrings("%USERDOMAIN%")
  strHostname = wshShell.ExpandEnvironmentStrings("%COMPUTERNAME%")
  command = URL_PREFIX+"://"+ServerName+"/userapi/registration?username="+strUser+"&domain="+strDomain+"&hostname="+strHostname+"&action=login&secretKey=<<CHANGEME>>"
  'WScript.Echo command
  AJAX.Open "GET", command
  AJAX.Send ""
  WScript.sleep(SLEEP_PERIOD)
  AJAX.Abort 
  Set AJAX = nothing
Loop

