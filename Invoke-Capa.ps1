param(
    $Path,
    $Output=".\results\capa",
    $CapaPath ="capa.exe"
)
# 
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

$param = "$Path"
Start-Process -FilePath $CapaPath -ArgumentList $param -Wait -NoNewWindow -RedirectStandardOutput "$basePath\capa-log.txt" -RedirectStandardError "$basePath\capa-error.txt"