function Get-ProcessFileVersion {
  $result = Get-Process -FileVersionInfo 
  ,$result
}