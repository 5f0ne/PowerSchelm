param(
    $Path,
    $Output=".\results\sigcheck",
    $SigcheckPath ="sigcheck.exe"
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

$param = "-nobanner -a -c -e -h -s -w $basePath\sigcheck.csv $Path"
Start-Process -FilePath $SigcheckPath -ArgumentList $param -Wait -NoNewWindow -RedirectStandardOutput "$basePath\sigcheck-log.txt" -RedirectStandardError "$basePath\sigcheck-error.txt"