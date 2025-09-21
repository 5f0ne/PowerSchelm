function Export-PowerShellHistory {
    param(
        $Path
    )
    # Finds all powershell files in powershell history standard path
    $psHistoryPath = $env:APPDATA + "\Microsoft\Windows\Powershell\PSReadLine"
    Get-ChildItem -Path $psHistoryPath -Force | ForEach-Object {
        # if the file name contains spaces they are replaced with underscores
        $fileName = "powershell-history-" + $_.Name.Replace(" ", "_")
        Get-Content -LiteralPath $_.FullName | Out-File -FilePath "$Path\$fileName"
    }
}