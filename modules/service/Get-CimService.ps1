function Get-CimService {
  $result = Get-CimInstance -Class Win32_Service
  ,$result
}