function Get-CimProcess {
  $result = Get-CimInstance -Class Win32_Process
  ,$result
}