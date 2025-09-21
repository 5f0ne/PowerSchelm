function Invoke-AutostartEnum {
    param (
        $Path
    )
    $currentUserAutoStart = $env:APPDATA + "\Microsoft\Windows\Start Menu\Programs\Startup"
    $systemAutoStart = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp"

    $p = "$Path\autostart-folder-current-user.csv"
    Get-ChildItem -Path $currentUserAutoStart -Recurse -Force | Select-Object Extension, Length, CreationTimeUtc, LastAccessTimeUtc, LastWriteTimeUtc, FullName | 
    Export-Csv $p -NoTypeInformation
    $p = "$Path\autostart-folder-system.csv"
    Get-ChildItem -Path $systemAutoStart -Recurse -Force | Select-Object Extension, Length, CreationTimeUtc, LastAccessTimeUtc, LastWriteTimeUtc, FullName | 
    Export-Csv $p -NoTypeInformation
}