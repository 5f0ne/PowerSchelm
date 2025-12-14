param(
    $Path,
    $Output = ".\results\downloads-listing"
)

#---------------------------------------------------------------------------------------------------------
# Import
#---------------------------------------------------------------------------------------------------------

. $PSScriptRoot\modules\common\New-Directory.ps1

#---------------------------------------------------------------------------------------------------------
# Setup
#---------------------------------------------------------------------------------------------------------

$startDateTime = (Get-Date).ToUniversalTime()
$startDateTimeFormatStr = $startDateTime.ToString("dd-MM-yyyy_HH-mm-ssZ")
$basePath = "$Output\$startDateTimeFormatStr"

New-Directory -Path $basePath

#---------------------------------------------------------------------------------------------------------
# Logic
#---------------------------------------------------------------------------------------------------------

$Results = @()

# Enumerate user profile directories
Get-ChildItem -LiteralPath "$Path\Users" -Directory -Force -ErrorAction SilentlyContinue |
Where-Object { $_.Name -notin @("All Users", "Default", "Default User", "Public") } |
ForEach-Object {

    $DownloadsPath = Join-Path $_.FullName "Downloads"

    if (Test-Path -LiteralPath $DownloadsPath) {
        Get-ChildItem -LiteralPath $DownloadsPath -Force -ErrorAction SilentlyContinue |
        ForEach-Object {
            $Results += [PSCustomObject]@{
                UserName       = $_.FullName.Split("\")[2]
                ItemType       = if ($_.PSIsContainer) { "Directory" } else { "File" }
                DownloadsRoot  = $DownloadsPath
                CreationTime   = $_.CreationTime
                LastWriteTime  = $_.LastWriteTime
                LastAccessTime = $_.LastAccessTime
                Name           = $_.Name
                FullName       = $_.FullName
                SizeBytes      = if ($_.PSIsContainer) { $null } else { $_.Length }

            }
        }
    }
}

# Sort newest first
$ResultsSorted = $Results | Sort-Object CreationTime -Descending

# Export to CSV
$CsvPath = Join-Path $basePath "files-in-downloads.csv"
$ResultsSorted | Export-Csv -Path $CsvPath -NoTypeInformation -Encoding UTF8