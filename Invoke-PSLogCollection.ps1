param(
    $Path,
    $Output = ".\results\pslogcollection"
)

#---------------------------------------------------------------------------------------------------------
# Function
#---------------------------------------------------------------------------------------------------------

function Copy-WithFullStructure {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]$Source,

        [Parameter(Mandatory)]
        [string]$DestinationRoot
    )

    process {
        foreach ($src in $Source) {

            if (-not (Test-Path $src)) {
                Write-Warning "Source not found: $src"
                continue
            }

            # Extract drive letter (C:)
            $drive = (Split-Path $src -Qualifier).TrimEnd(':')

            # Get path without drive prefix (e.g., Data\Projects\File.txt)
            $relative = $src.Substring(3)  # Removes "C:\"

            # Build full target path
            $dest = Join-Path $DestinationRoot "$drive\$relative"

            # Create directories
            $destDir = Split-Path $dest
            if (-not (Test-Path $destDir)) {
                New-Item -ItemType Directory -Path $destDir -Force | Out-Null
            }

            # Copy file
            Copy-Item $src $dest -Force
        }
    }
}

#---------------------------------------------------------------------------------------------------------
# Import
#---------------------------------------------------------------------------------------------------------

. $PSScriptRoot\modules\common\New-Directory.ps1

#---------------------------------------------------------------------------------------------------------
# Setup
#---------------------------------------------------------------------------------------------------------

$error.Clear()
$startDateTime = (Get-Date).ToUniversalTime()
$startDateTimeFormatStr = $startDateTime.ToString("dd-MM-yyyy_HH-mm-ssZ")
$basePath = "$Output\$startDateTimeFormatStr"

New-Directory -Path $basePath

#---------------------------------------------------------------------------------------------------------
# Logic
#---------------------------------------------------------------------------------------------------------

# Define transcript file pattern
$transcriptPattern = "PowerShell_transcript*.txt"
    
$transcriptFiles = Get-ChildItem -Path $Path -Filter $transcriptPattern -Force -Recurse -ErrorAction SilentlyContinue
$csvOutput = Join-Path $basePath "transcript-hashes.csv"
$results = @()

if ($transcriptFiles) {
    $transcriptFiles | ForEach-Object {
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $srcPath = $_.FullName
        $srcSize = $_.Length

        # 1) Calculate source hash
        $srcHash = Get-FileHash -Path $srcPath -Algorithm SHA256

        # 2) Build destination path 
        $drive = (Split-Path $_.FullName -Qualifier).TrimEnd(':')
        $relative = $_.FullName.Substring(3)
        $destPath = Join-Path $basePath "$drive\$relative"

        # 3) Copy
        Copy-WithFullStructure -Source $_.FullName -DestinationRoot $basePath

        # 4) Calculate destination hash + file size
        $destHashObj = $null
        $destSize = $null
        $hashMatch = $false

        if (Test-Path $destPath) {
            $destHashObj = Get-FileHash -Path $destPath -Algorithm SHA256
            # Destination file size
            $destSize = (Get-Item $destPath).Length

            $hashMatch = $srcHash.Hash -eq $destHashObj.Hash
        }
        else {
            Write-Warning "Destination file missing after copy: $destPath"
        }


        # 4) Build result object for CSV
        $results += [PSCustomObject]@{
            Timestamp           = $timestamp
            FileName            = $_.Name
            SourcePath          = $srcPath
            DestinationPath     = $destPath
            SourceFileSize      = $srcSize
            DestinationFileSize = $destSize
            SourceSHA256        = $srcHash.Hash
            DestinationSHA256   = if ($destHashObj) { $destHashObj.Hash } else { $null }
            HashMatch           = $hashMatch
        }
    }
    # Export to CSV
    $results | Export-Csv -Path $csvOutput -NoTypeInformation -Encoding UTF8


}
else {
    Write-Host "No PowerShell Transcripts found!"
}

# Define readline file pattern
$readLinePattern = "*_history.txt"
$csvOutput = Join-Path $basePath "readline-hashes.csv"
$results = @()
    
$readLineFiles = Get-ChildItem -Path $Path -Filter $readLinePattern -Force -Recurse -ErrorAction SilentlyContinue

if ($readLineFiles) {
    $readLineFiles | ForEach-Object {
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $srcPath = $_.FullName
        $srcSize = $_.Length

        # 1) Calculate source hash
        $srcHash = Get-FileHash -Path $srcPath -Algorithm SHA256

        # 2) Build destination path 
        $drive = (Split-Path $_.FullName -Qualifier).TrimEnd(':')
        $relative = $_.FullName.Substring(3)
        $destPath = Join-Path $basePath "$drive\$relative"
        Copy-WithFullStructure -Source $_.FullName -DestinationRoot $basePath

        # 4) Calculate destination hash + file size
        $destHashObj = $null
        $destSize = $null
        $hashMatch = $false

        if (Test-Path $destPath) {
            $destHashObj = Get-FileHash -Path $destPath -Algorithm SHA256
            # Destination file size
            $destSize = (Get-Item $destPath).Length

            $hashMatch = $srcHash.Hash -eq $destHashObj.Hash
        }
        else {
            Write-Warning "Destination file missing after copy: $destPath"
        }

        # 4) Build result object for CSV
        $results += [PSCustomObject]@{
            Timestamp           = $timestamp
            FileName            = $_.Name
            SourcePath          = $srcPath
            DestinationPath     = $destPath
            SourceFileSize      = $srcSize
            DestinationFileSize = $destSize
            SourceSHA256        = $srcHash.Hash
            DestinationSHA256   = if ($destHashObj) { $destHashObj.Hash } else { $null }
            HashMatch           = $hashMatch
        }
    }
    # Export to CSV
    $results | Export-Csv -Path $csvOutput -NoTypeInformation -Encoding UTF8
}
else {
    Write-Host "No PowerShell ReadLine Files found!"
}