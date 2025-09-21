function Get-InstalledPrograms {
    param(
        $Path
    )
    Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | 
    Export-Csv "$Path\installed-programs.csv" -NoTypeInformation
}