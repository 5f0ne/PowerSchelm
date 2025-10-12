param(
    $Path,
    $Output = ".\results\sigcheck",
    $SigcheckPath = "sigcheck.exe"
)
# 
#---------------------------------------------------------------------------------------------------------
# Import
#---------------------------------------------------------------------------------------------------------

. $PSScriptRoot\modules\common\New-Directory.ps1
. $PSScriptRoot\modules\common\Get-FileBom.ps1
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

$param = "-nobanner -a -c -e -h -s -w $basePath\sigcheck.csv $Path"
Write-Host "CMD: $param"
chcp 65001 > $null
Start-Process -FilePath $SigcheckPath -ArgumentList $param -Wait -NoNewWindow -RedirectStandardOutput "$basePath\sigcheck-log.txt" -RedirectStandardError "$basePath\sigcheck-error.txt"

# UTF8 encoding needed
Get-Content "$basePath\sigcheck.csv" -Encoding OEM | Set-Content "$basePath\sigcheck-utf8.csv" -Encoding UTF8
Remove-Item -Path "$basePath\sigcheck.csv" 
# Remove BOM
# Since the output is encoded as UTF8 with BOM, the BOM bytes need to be removed
$path = "$basePath\sigcheck-utf8.csv"
$isBom = Get-FileBom -Path $path

if ($isBom) {
    Write-Host "BOM detected!"
    $b = [IO.File]::ReadAllBytes($path)
    if ($b.Length -ge 3 -and $b[0] -eq 0xEF -and $b[1] -eq 0xBB -and $b[2] -eq 0xBF) {
        [IO.File]::WriteAllBytes($path, $b[3..($b.Length - 1)])
    }
}
