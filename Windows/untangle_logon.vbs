'Handle or Ignore all errors
On Error Resume Next

'Time in milliseconds to sleep between request
SLEEP_PERIOD = 300000

URL_PREFIX = "http"

If WScript.Arguments.Count = 1 Then
	ServerName = WScript.Arguments.Item(0)
Else
	ServerName = "10.1.0.1"
End If

'WScript.Echo "ServerName is:"
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

