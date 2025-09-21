function Get-RegistryValues {
    param($Path, $KeyName="")
    $result = "No value found!"
    if($KeyName -eq ""){
        $result = Get-ItemProperty $Path
    } else {
        $result = Get-ItemProperty $Path -Name $KeyName
    }
    return $result
}