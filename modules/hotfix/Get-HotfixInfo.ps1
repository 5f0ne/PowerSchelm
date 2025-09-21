function Get-HotfixInfo {
    param (
        $Path
    )
    Get-HotFix | Select-Object CSName, Description, HotFixID, InstalledBy, InstalledOn | Export-Csv "$Path\hotfixes.csv" -NoTypeInformation
}