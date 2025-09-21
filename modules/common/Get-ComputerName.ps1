function Get-ComputerName {
    return $env:computername.Replace(" ","_")
}