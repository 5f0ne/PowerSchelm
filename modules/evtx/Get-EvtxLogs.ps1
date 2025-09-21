function Get-EvtxLogs {
    param (
        $Path
    )
    Get-WinEvent -ListLog * -ComputerName localhost | Where-Object { $_.RecordCount } | 
    Select-Object LogMode, RecordCount, LogName, FileSize, LastAccessTime, LastWriteTime, LogFilePath | 
    Sort-Object -Descending -Property RecordCount |
    Export-Csv "$Path\available-event-logs.csv" -NoTypeInformation
}