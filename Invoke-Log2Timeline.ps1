param(
    $Path,
    $Output = "./results/log2timeline",
    $PSortOutput = "l2tcsv"
)

#---------------------------------------------------------------------------------------------------------
# Import
#---------------------------------------------------------------------------------------------------------

. $PSScriptRoot\modules\common\New-Directory.ps1

#---------------------------------------------------------------------------------------------------------
# Path and Folder Creation
#---------------------------------------------------------------------------------------------------------

# Path needs to be normalized for Win or Lin
$nOutput = [IO.Path]::GetFullPath($Output)

$startDateTime = (Get-Date).ToUniversalTime()
$startDateTimeFormatStr = $startDateTime.ToString("dd-MM-yyyy_HH-mm-ssZ")
$basePath = "$nOutput\$startDateTimeFormatStr"

New-Directory -Path $basePath

#---------------------------------------------------------------------------------------------------------
# log2timeline
#---------------------------------------------------------------------------------------------------------

Write-Host "log2timeline processing starting for: $Path"

$logPath = Join-Path -Path $basePath -ChildPath "plaso.log.gz"
$plasoPath = Join-Path -Path $basePath -ChildPath "result.plaso"
$outLogPath = Join-Path -Path $basePath -ChildPath "l2t-log.txt"
$outErrorPath = Join-Path -Path $basePath -ChildPath "l2t-error.txt"

$a = "log2timeline.py --storage_file $plasoPath --logfile $logPath --partitions all --vss_stores all --workers 4 $Path"
Start-Process -FilePath "sudo" -ArgumentList $a -Wait -NoNewWindow -RedirectStandardOutput $outLogPath -RedirectStandardError $outErrorPath

Write-Host "plaso file successfully created in $plasoPath"

#---------------------------------------------------------------------------------------------------------
# psort
#---------------------------------------------------------------------------------------------------------

Write-Host "---"
Write-Host "psort processing starting for: $plasoPath"

$logPath = Join-Path -Path $basePath -ChildPath "psort.log.gz"
$csvPath = Join-Path -Path $basePath -ChildPath "supertimeline.csv"
$outLogPath = Join-Path -Path $basePath -ChildPath "psort-log.txt"
$outErrorPath = Join-Path -Path $basePath -ChildPath "psort-error.txt"

$a = "psort.py --logfile $logPath -o $PSortOutput -w $csvPath $plasoPath"
Start-Process -FilePath "sudo" -ArgumentList $a -Wait -NoNewWindow -RedirectStandardOutput $outLogPath -RedirectStandardError $outErrorPath

Write-Host "supertimeline successfully created in $csvPath"