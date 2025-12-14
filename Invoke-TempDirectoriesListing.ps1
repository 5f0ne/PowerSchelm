param(
    $Path,
    $Output = ".\results\temp-listing"
)

#---------------------------------------------------------------------------------------------------------
# Function
#---------------------------------------------------------------------------------------------------------

function Get-FilesReport {
    param(
        [Parameter(Mandatory = $true)][string]$Root,
        [Parameter(Mandatory = $true)][string]$Category
    )

    if (-not (Test-Path -LiteralPath $Root)) { return @() }

    Get-ChildItem -LiteralPath $Root -Recurse -File -Force -ErrorAction SilentlyContinue |
    Select-Object `
    @{Name = "Category"; Expression = { $Category } },
    @{Name = "Root"; Expression = { $Root } },
    CreationTimeUtc,
    LastWriteTimeUtc,
    LastAccessTimeUtc,
    Extension,
    Length,
    @{Name = "SizeMB"; Expression = { [math]::Round($_.Length / 1MB, 2) } },
    Name,
    FullName
}

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

# -------------------------
# 1) Per-user temp folders
# -------------------------
$UserRoots = @()

# Enumerate actual profile directories (skipping common non-user junctions)
Get-ChildItem -LiteralPath "$Path\Users" -Directory -Force -ErrorAction SilentlyContinue |
Where-Object { $_.Name -notin @("All Users", "Default", "Default User", "Public") } |
ForEach-Object {
    $temp = Join-Path $_.FullName "AppData\Local\Temp"
    if (Test-Path -LiteralPath $temp) {
        $UserRoots += [PSCustomObject]@{
            UserDir  = $_.FullName
            UserName = $_.Name
            TempRoot = $temp
        }
    }
}

$UserFiles = foreach ($u in $UserRoots) {
    Get-FilesReport -Root $u.TempRoot -Category ("UserTemp:" + $u.UserName) |
    Select-Object *, @{Name = "UserName"; Expression = { $u.UserName } }, @{Name = "UserProfile"; Expression = { $u.UserDir } }
}

$UserCsv = Join-Path $basePath "temp-files-user.csv"
$UserFiles | Sort-Object LastWriteTimeUtc -Descending | Export-Csv -Path $UserCsv -NoTypeInformation -Encoding UTF8

# -------------------------
# 2) System temp locations
# -------------------------
$SystemRoots = @(
    "$Path\Windows\Temp",
    "$Path\Windows\Logs\CBS",
    "$Path\Windows\Logs\DISM",
    "$Path\Windows\Panther",
    "$Path\Windows\SoftwareDistribution\Download",
    "$Path\Windows\SoftwareDistribution\Temp",
    "$Path\ProgramData",
    "$Path\ProgramData\Temp",
    "$Path\Windows\ServiceProfiles\LocalService\AppData\Local\Temp",
    "$Path\Windows\ServiceProfiles\NetworkService\AppData\Local\Temp"
) | Where-Object { $_ -and ($_ -ne "") } | Select-Object -Unique

$SystemFiles = foreach ($root in $SystemRoots) {
    Get-FilesReport -Root $root -Category "SystemTemp"
}

$SystemCsv = Join-Path $basePath "temp-files-system.csv"
$SystemFiles | Sort-Object LastWriteTimeUtc -Descending | Export-Csv -Path $SystemCsv -NoTypeInformation -Encoding UTF8