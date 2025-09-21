function Invoke-ShortcutEnum {
    param (
        $ResultPath,
        $LnkEnumPath
    )
    $p = "$ResultPath\shortcut-target-enumeration.csv"
    $result_array = @() 
    Get-ChildItem -Path $LnkEnumPath -Filter *.lnk -Recurse | Get-ItemProperty | ForEach-Object {
        $sh = New-Object -ComObject WScript.Shell
        $target = $sh.CreateShortcut($_.FullName).TargetPath
        $arguments = $sh.CreateShortcut($_.FullName).Arguments
        $obj = New-Object -TypeName PSObject -Property @{
            "Name"      = $_.FullName
            "Target"    = $target
            "Arguments" = $arguments
        }
        $result_array += $obj
        [Runtime.InteropServices.Marshal]::ReleaseComObject($sh) | Out-Null
    }
    $result_array | Select-Object Name, Target, Arguments | Export-Csv $p -NoTypeInformation
}