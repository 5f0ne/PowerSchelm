param(
    $Path,
    $Output = ".\results\mft-tl",
    $DriveLetter = "C",
    $MfteCmdPath = "MFTECmd.exe",
    $PerlPath = "perl.exe",
    $TskPathWord = "SleuthKit"
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

$TskPath = ""

$paths = $env:PATH -Split ';'
foreach ($p in $paths) {
    if ($p.Contains($TskPathWord)) {  
        $TskPath = $p
        break
    }
}

#---------------------------------------------------------------------------------------------------------
# Create Body File
#---------------------------------------------------------------------------------------------------------

$param = "-f $Path --body $basePath --bodyf tl.body --bdl $DriveLetter"
Write-Host $param
Start-Process -FilePath $MfteCmdPath -ArgumentList $param -Wait -NoNewWindow -RedirectStandardOutput "$basePath\mftecmd-log.txt" -RedirectStandardError "$basePath\mftecmd-error.txt"

#---------------------------------------------------------------------------------------------------------
# Parse body file with mactime
#---------------------------------------------------------------------------------------------------------

$param = "$TskPath\mactime.pl -b $basePath\tl.body -d -z UTC"
Write-Host $param
Start-Process -FilePath $PerlPath -ArgumentList $param -Wait -NoNewWindow -RedirectStandardOutput "$basePath\mft-timeline.csv" -RedirectStandardError "$basePath\mfttl-error.txt"