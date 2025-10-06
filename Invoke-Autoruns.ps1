# Invokes Autorunsc on an image
param($ErrorActionPreference = "SilentlyContinue",
    $Path,
    $Windows = "Windows",
    $Users = "Users",
    $Output = ".\results\autorunsc",
    $AutorunscPath = "autorunsc.exe"
)


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

$windowsPath = "$Path\$Windows"
$userPath = "$Path\$Users"

Write-Host $windowsPath
Write-Host $userPath

Get-ChildItem $userPath -Directory | ForEach-Object {
    reg unload HKLM\autoruns.software
    reg unload HKLM\autoruns.system
    reg unload HKLM\autoruns.user
    $prof = $_.FullName 
    $param = "-accepteula -nobanner -a * -t -c -h -s -z $windowsPath $prof"
    Write-Host $param
    Start-Process -FilePath $AutorunscPath -ArgumentList $param -Wait -NoNewWindow -RedirectStandardOutput "$basePath\autoruns_$($_.Name).csv" -RedirectStandardError "$basePath\autorunsc-error.txt"
}