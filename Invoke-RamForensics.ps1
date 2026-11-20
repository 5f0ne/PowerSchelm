<# 
Prerequisites:
pip install volatility3
Install EZ-Tools and put them to path
#>
param($ErrorActionPreference = "SilentlyContinue", 
    # Path to memory dumps
    [string]$Path,
    # Output path
    [string]$Output = ".\results\ramforensics",
    # String length
    $StringLength = 10,
    # If true, zip the result files
    $Archive = $false, 
    $ArchiveName = "ramforensics",
    $ApplyBstringsRegex = $false
)

#---------------------------------------------------------------------------------------------------------
# Import
#---------------------------------------------------------------------------------------------------------

. $PSScriptRoot\modules\common\New-Directory.ps1
. $PSScriptRoot\modules\common\Export-ExecutionTime.ps1
. $PSScriptRoot\modules\common\Export-FileHashes.ps1
. $PSScriptRoot\modules\common\New-Archive.ps1

. $PSScriptRoot\modules\output\Export-AsFile.ps1

#---------------------------------------------------------------------------------------------------------
# Setup
#---------------------------------------------------------------------------------------------------------

$error.Clear()
$startDateTime = (Get-Date).ToUniversalTime()
$startDateTimeFormatStr = $startDateTime.ToString("dd-MM-yyyy_HH-mm-ssZ")
$basePath = "$Output\$startDateTimeFormatStr"

# Output dir
New-Directory -Path $basePath


#---------------------------------------------------------------------------------------------------------
# Logic
#---------------------------------------------------------------------------------------------------------


.\Invoke-Bstrings.ps1 -Path $Path -Output "$Output\ramforensics\01-bstrings" -StringLength $StringLength -ApplyBuildinRegex $ApplyBstringsRegex
.\Invoke-Volatility3.ps1 -Path $Path -Output "$Output\ramforensics\02-vol3"


#---------------------------------------------------------------------------------------------------------
# Execution Time
#---------------------------------------------------------------------------------------------------------

# Write Execution Time
Export-ExecutionTime -Path $basePath -StartDateTime $startDateTime -StartDateTimeFormatStr $startDateTimeFormatStr

#---------------------------------------------------------------------------------------------------------
# Error
#---------------------------------------------------------------------------------------------------------

# Save errors
$pathBase = "$basePath\99-error"
New-Directory -Path $pathBase

$error | Export-AsFile -Path "$pathBase\error.txt"

#---------------------------------------------------------------------------------------------------------
# Hash all Files
#---------------------------------------------------------------------------------------------------------

Export-FileHashes -HashPath $basePath -ResultPath $basePath

#---------------------------------------------------------------------------------------------------------
# Create archive
#---------------------------------------------------------------------------------------------------------

if ($Archive) {
    New-Archive -ResultPath $Output -ArchivePath $basePath -FileName "$ArchiveName.$startDateTimeFormatStr"
}