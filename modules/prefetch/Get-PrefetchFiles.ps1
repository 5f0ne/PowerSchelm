function Get-PrefetchFiles {
    param (
        $Path
    )
    Get-ChildItem "C:\Windows\Prefetch\" -Force -Filter "*.pf" | Select-Object CreationTimeUtc, LastAccessTimeUtc, LastWriteTimeUtc, Length, FullName | 
    Sort-Object -Property CreationTimeUtc -Descending | 
    Export-Csv "$Path\prefetch-files.csv" -NoTypeInformation
}