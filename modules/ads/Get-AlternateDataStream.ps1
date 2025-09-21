function Get-AlternateDataStream {
    param (
        $ResultPath,
        $AdsEnumPath
    )
    $p = "$ResultPath\alternate-data-streams.csv"
    $ads_content = "$ResultPath\alternate-data-streams-content.txt"
    $ads_array = @()
    # Iterate over path and get all files with an alternate data stream
    Get-ChildItem -Path $AdsEnumPath -Recurse -Force | Get-Item -Stream * | Where-Object { $_.Stream -ne ":`$DATA" } | ForEach-Object {
        # Extract the content of the alternate data stream and write it to a file as a hexdump
        $filenameAndStream = "`n`n$($_.FileName):$($_.Stream)" 
        $filenameAndStream | Out-File -Append -FilePath $ads_content
        Get-Content -LiteralPath $_.FileName -Stream $_.Stream -Raw | Format-Hex | Out-File -Append -FilePath $ads_content
        $line = "----------------------------------------------------------------------------------------------------------"
        $line | Out-File -Append -FilePath $ads_content
        # Get the filename, stream name and length of the ads
        $obj = New-Object -TypeName PSObject -Property @{
            "FileName" = $_.FileName
            "Stream"   = $_.Stream
            "Length"   = $_.Length
        }
        $ads_array += $obj
    }
    # Save ADS properties into csv file
    $ads_array | Select-Object Length, FileName, Stream | Export-Csv $p -NoTypeInformation
}