param($ErrorActionPreference = "SilentlyContinue",
    $Path,
    $Output = ".\results\autostart-listing"
)

#---------------------------------------------------------------------------------------------------------
# Import
#---------------------------------------------------------------------------------------------------------

. $PSScriptRoot\modules\common\New-Directory.ps1
. $PSScriptRoot\modules\file\Invoke-AutostartEnum.ps1

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

Get-ChildItem -LiteralPath "$Path\Users" -Directory -Force -ErrorAction SilentlyContinue |
Where-Object { $_.Name -notin @("All Users", "Default", "Default User", "Public") } |
ForEach-Object {

    $StartupPath = Join-Path $_.FullName "AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
    Write-Host $StartupPath
    if (Test-Path -LiteralPath $StartupPath) {
        Get-ChildItem -LiteralPath $StartupPath -Force -ErrorAction SilentlyContinue |
        ForEach-Object {
            $Results += [PSCustomObject]@{
                UserName       = $_.FullName.Split("\")[2]
                ItemType       = if ($_.PSIsContainer) { "Directory" } else { "File" }
                StartupRoot    = $StartupPath
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
$CsvPath = Join-Path $basePath "autostart-folder-users.csv"
$ResultsSorted | Export-Csv -Path $CsvPath -NoTypeInformation -Encoding UTF8

# ---
# System
# ---
$systemAutoStart = "$Path\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp"
$p = "$basePath\autostart-folder-system.csv"
Get-ChildItem -Path $systemAutoStart -Recurse -Force | Select-Object Extension, Length, CreationTimeUtc, LastAccessTimeUtc, LastWriteTimeUtc, FullName | 
Export-Csv $p -NoTypeInformation