function GetSecurityEventIds {
    param (
        $ErrorActionPreference="SilentlyContinue"
    )
    
    $result = Get-WinEvent -LogName 'Microsoft-Windows-Sysmon/Operational' | Group-Object Id | Sort-Object Count -Descending | Select-Object Name, Count
    $result | Export-Csv -Path "sysmon-overview.csv" -NoTypeInformation
}