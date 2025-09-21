function New-Archive {
    param (
        $ResultPath,
        $ArchivePath,
        $FileName
    )
    Start-Sleep(5)
    $IntermediateArchive = "$ResultPath\$FileName.archive.zip"
    $currentPathWithoutRoot = $ArchivePath + "\*"
    Compress-Archive -Path $currentPathWithoutRoot -DestinationPath $IntermediateArchive -Force
    
    # Hash the intermediate archive
    $hashes = Get-Hashes -Path $IntermediateArchive
    $hash_array = @($hashes)
    $p = "$ResultPath\$FileName.archive.hashes.csv"
    $hash_array | Select-Object FullName, MD5, SHA256 | Export-Csv $p -NoTypeInformation
    # Create final archive
    $finalArchive = "$ResultPath\$FileName.archive.final.zip"
    $archiveConfig = @{
        LiteralPath      = $IntermediateArchive, $p
        CompressionLevel = "Optimal"
        DestinationPath  = $finalArchive
    }
    Compress-Archive @archiveConfig
    # Hash final archive
    $hashes = Get-Hashes -Path $finalArchive
    $hash_array = @($hashes)
    $p = "$ResultPath\$FileName.archive.final.hashes.csv"
    $hash_array | Select-Object FullName, MD5, SHA256 | Export-Csv $p -NoTypeInformation 
}