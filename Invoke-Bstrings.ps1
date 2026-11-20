<# 
Prerequisites:
Install EZ-Tools and put them to path
#>
param($ErrorActionPreference = "SilentlyContinue", 
    # Path to memory dumps
    [string]$Path,
    # Output path
    [string]$Output = ".\results\bstrings",
    # String length
    $StringLength = 10,
    # If true, applies all built-in Regex
    $ApplyBuildinRegex = $False,
    $BstringsPath = "bstrings.exe"
)

#---------------------------------------------------------------------------------------------------------
# Import
#---------------------------------------------------------------------------------------------------------

. $PSScriptRoot\modules\common\New-Directory.ps1
. $PSScriptRoot\modules\common\Export-ExecutionTime.ps1

#---------------------------------------------------------------------------------------------------------
# Setup
#---------------------------------------------------------------------------------------------------------

$error.Clear()
$startDateTime = (Get-Date).ToUniversalTime()
$startDateTimeFormatStr = $startDateTime.ToString("dd-MM-yyyy_HH-mm-ssZ")
$basePath = "$Output\$startDateTimeFormatStr"

# Output dir
New-Directory -Path $basePath

# --------------------------------------------------------------------------------------------------------------
# bstrings
# --------------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\01-all"
New-Directory -Path $pathBase

$p = "$pathBase\bstrings-all.txt"
$stdOut = "$pathBase\bstrings-log.txt"
$stdErr = "$pathBase\bstrings-error.txt"
Start-Process -FilePath $BstringsPath -ArgumentList "-s -f $Path -o $p -m $StringLength --sl --sa" -RedirectStandardOutput $stdOut -RedirectStandardError $stdErr -NoNewWindow -Wait

if ($ApplyBuildinRegex) {
    $pathBase = "$basePath\02-regex"
    New-Directory -Path $pathBase

    $items = "aeon", "b64", "bitcoin", "bitlocker", "bytecoin", 
    "cc", "dashcoin", "dashcoin2", "email", "fantomcoin", "guid", 
    "ipv4", "ipv6", "mac", "monero", "reg_path", "sid", "ssn",
    "sumokoin", "unc", "url3986", "urlUser", "usPhone", "var_set", 
    "win_path", "xml", "zip"

    foreach ($i in $items) {
        $p = "$pathBase\bstrings-$i.txt"
        $stdOut = "$pathBase\bstrings-$i-log.txt"
        $stdErr = "$pathBase\bstrings-$i-error.txt"
        Start-Process -FilePath $BstringsPath -ArgumentList "-s -f $Path -o $p --sl --sa --lr $i" -RedirectStandardOutput $stdOut -RedirectStandardError $stdErr -NoNewWindow -Wait
    }
}

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