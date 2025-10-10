param(
    $JPath,
    $MftPath,
    $Output = ".\results\mft-usnjrnl",
    $MfteCmdPath = "MFTECmd.exe"
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
# Parse $UsnJrnl
#---------------------------------------------------------------------------------------------------------

$param = "-f $JPath -m $MftPath --csv $basePath --csvf usnjrnl.csv"
Start-Process -FilePath $MfteCmdPath -ArgumentList $param -Wait -NoNewWindow -RedirectStandardOutput "$basePath\usnjrnl-log.txt" -RedirectStandardError "$basePath\usnjrnl-error.txt"

# Since the output is encoded as UTF8 with BOM, the BOM bytes need to be removed
$path = "$basePath\usnjrnl.csv"; 
$b = [IO.File]::ReadAllBytes($path)
if ($b.Length -ge 3 -and $b[0] -eq 0xEF -and $b[1] -eq 0xBB -and $b[2] -eq 0xBF) {
    [IO.File]::WriteAllBytes($path, $b[3..($b.Length - 1)])
}