param ( $ErrorActionPreference = "SilentlyContinue",
    $Path,
    $Output = ".\results\hayabusaforensics",
    $HayabusaPath = "hayabusa.exe"
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

# csv-timeline / Create a DFIR timeline and save it in CSV format
$p = "$basePath\csv-timeline"
New-Directory -Path $p

$param = "csv-timeline -d $Path -w -s -A -K -v -T -U -o $p\hayabusa-timeline.csv"
Start-Process -FilePath $HayabusaPath -ArgumentList $param -Wait -NoNewWindow -RedirectStandardOutput "$p\hayabusa-timeline-log.txt" -RedirectStandardError "$p\hayabusa-timeline-error.txt"

# eid-metrics / Output event ID metrics
$p = "$basePath\eid-metrics"
New-Directory -Path $p

$param = "eid-metrics -K -v -U -o $p\hayabusa-eid-metrics.csv -d $Path"
Start-Process -FilePath $HayabusaPath -ArgumentList $param -Wait -NoNewWindow -RedirectStandardOutput "$p\hayabusa-eid-metrics-log.txt" -RedirectStandardError "$p\hayabusa-eid-metrics-error.txt"


# logon-summary / Output a summary of successful and failed logons
$p = "$basePath\logon-summary"
New-Directory -Path $p

$param = "logon-summary -K -v -U -o $p\hayabusa-logon-summary.csv -d $Path"
Start-Process -FilePath $HayabusaPath -ArgumentList $param -Wait -NoNewWindow -RedirectStandardOutput "$p\hayabusa-logon-summary-log.txt" -RedirectStandardError "$p\hayabusa-logon-summary-error.txt"