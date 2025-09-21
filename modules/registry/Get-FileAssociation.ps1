function Get-FileAssociation {
    param (
        $Path
    )
    $p = "$Path\file-association-enumeration.csv"
    $command_array = @()

    Get-ChildItem "Registry::HKEY_CLASSES_ROOT\" -Recurse -Force | ForEach-Object {
        if ($_.Name.toLower().Contains("shell\open\command")) {
            $path = "Registry::" + $_.Name
            $cmd = (Get-ItemProperty -LiteralPath $path).'(default)'
            $obj = New-Object -TypeName PSObject -Property @{
                "KeyName" = $_.Name
                "Command" = $cmd
            }
            $command_array += $obj
        }
    }
    $command_array | Select-Object KeyName, Command | Export-Csv $p -NoTypeInformation
}