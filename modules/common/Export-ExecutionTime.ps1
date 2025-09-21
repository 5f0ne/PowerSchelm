function Export-ExecutionTime {
    param (
        $Path,
        $StartDateTime,
        $StartDateTimeFormatStr
    )
    $endDateTime = (Get-Date).ToUniversalTime()
    $endDateTimeFormatStr = $endDateTime.ToString("dd-MM-yyyy_HH-mm-ssZ")

    $elapsedTime = $endDateTime - $StartDateTime

    $obj = New-Object -TypeName PSObject -Property @{
        "Duration" = $elapsedTime
        "End"      = $endDateTimeFormatStr
        "Start"    = $StartDateTimeFormatStr
    }

    $obj | Format-List | Out-File -FilePath "$Path\execution-time.txt"
}