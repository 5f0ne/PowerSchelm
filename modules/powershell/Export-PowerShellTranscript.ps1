function Export-PowerShellTranscript {
    param(
        $Path
    )

    $p = "$Path\powershell-transcripts.csv"
    $defaultTranscriptPath = Join-Path $env:USERPROFILE "Documents"

    # Define transcript file pattern
    $transcriptPattern = "PowerShell_transcript*.txt"

    # Check if directory exists
    if (Test-Path $defaultTranscriptPath) {
        # Search for transcript files
        $transcriptFiles = Get-ChildItem -Path $defaultTranscriptPath -Filter $transcriptPattern -Force -Recurse -ErrorAction SilentlyContinue

        if ($transcriptFiles) {
            # Create overview csv
            $transcriptFiles | Select-Object CreationTimeUtc, LastAccessTimeUtc, LastWriteTimeUtc, Length, FullName | Export-Csv $p -NoTypeInformation
            $transcriptFiles | ForEach-Object {
                $p = "$Path\" + $_.Name.Replace(" ", "_")
                Get-Content -LiteralPath $_.FullName | Out-File -FilePath $p
            }
        }
    }
}