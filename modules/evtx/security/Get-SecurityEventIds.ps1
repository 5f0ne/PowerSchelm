function Get-SecurityEventIds {
    param (
        #$ErrorActionPreference="SilentlyContinue",
        $Path = ""
    )

    if ($Path -eq "") {
        $events = Get-WinEvent -LogName Security
    }
    else {
        $events = Get-WinEvent -Path $Path
    }
    Write-Host "Events loaded"
    $result = $events | Group-Object Id | Select-Object Name, Count | Sort-Object Count -Descending
    Write-Host "Events sorted"
    $result | Export-Csv -Path "security-overview.csv" -NoTypeInformation
}