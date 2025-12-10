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
    $Bstrings = $False
)

#---------------------------------------------------------------------------------------------------------
# Function
#---------------------------------------------------------------------------------------------------------

function Invoke-VolatilityModule {
    param (
        $ImagePath,
        $FileName,
        $ModuleName,
        $BasePath
    )

    $tmp = "$BasePath\$FileName.tmp"
    $p = "$BasePath\$FileName.txt"
    $c = "$BasePath\$FileName.csv"
    $e = "$BasePath\$FileName-log.txt"
    Start-Process -FilePath "vol.exe" -ArgumentList "-f $Path -r pretty $ModuleName" -RedirectStandardOutput $tmp -RedirectStandardError $e -NoNewWindow -Wait
    # Removes the first line from volatility output
    (Get-Content $tmp | Select-Object -Skip 1) | Set-Content $p -Encoding utf8
    Import-Csv -Path $p -Delimiter "|" | Select-object * | Export-Csv $c -NoTypeInformation
    Remove-Item -LiteralPath $tmp -Force
}

#---------------------------------------------------------------------------------------------------------
# Import
#---------------------------------------------------------------------------------------------------------

. $PSScriptRoot\modules\common\New-Directory.ps1
. $PSScriptRoot\modules\common\Get-Hashes.ps1
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

# --------------------------------------------------------------------------------------------------------------
# EZ Tools
# --------------------------------------------------------------------------------------------------------------
# bstrings
# --------------------------------------------------------------------------------------------------------------


if($Bstrings){ 
    $pathBase = "$basePath\01-bstrings"
    New-Directory -Path $pathBase

    $p = "$pathBase\bstrings-all.txt"
    $stdOut = "$pathBase\bstrings-log.txt"
    $stdErr = "$pathBase\bstrings-error.txt"
    Start-Process -FilePath "bstrings.exe" -ArgumentList "-s -f $Path -o $p -m $StringLength --sl --sa" -RedirectStandardOutput $stdOut -RedirectStandardError $stdErr -NoNewWindow -Wait

    $items = "aeon", "b64", "bitcoin", "bitlocker", "bytecoin", 
    "cc", "dashcoin", "dashcoin2", "email", "fantomcoin", "guid", 
    "ipv4", "ipv6", "mac", "monero", "reg_path", "sid", "ssn",
    "sumokoin", "unc", "url3986", "urlUser", "usPhone", "var_set", 
    "win_path", "xml", "zip"

    foreach ($i in $items) {
        $p = "$pathbase\bstrings-$i.txt"
        Start-Process -FilePath "bstrings.exe" -ArgumentList "-s -f $Path -o $p --sl --sa --lr $i" -RedirectStandardOutput $stdOut -RedirectStandardError $stdErr -NoNewWindow -Wait
    }
}

# --------------------------------------------------------------------------------------------------------------
# Volatility3
# --------------------------------------------------------------------------------------------------------------
# Process
# --------------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\02-processes"
New-Directory -Path $pathBase

Invoke-VolatilityModule -ImagePath $Path -FileName "pstree" -ModuleName "windows.pstree.PsTree" -BasePath $pathBase
Invoke-VolatilityModule -ImagePath $Path -FileName "psscan" -ModuleName "windows.psscan.PsScan" -BasePath $pathBase
Invoke-VolatilityModule -ImagePath $Path -FileName "psxview" -ModuleName "windows.malware.psxview.PsXView" -BasePath $pathBase

# --------------------------------------------------------------------------------------------------------------
# ScheduledTasks
# --------------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\03-scheduled-tasks"
New-Directory -Path $pathBase

Invoke-VolatilityModule -ImagePath $Path -FileName "scheduled-tasks" -ModuleName "windows.registry.scheduled_tasks.ScheduledTasks" -BasePath $pathBase

# --------------------------------------------------------------------------------------------------------------
# DLLs
# --------------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\04-dlllist"
New-Directory -Path $pathBase

Invoke-VolatilityModule -ImagePath $Path -FileName "dlllist" -ModuleName "windows.dlllist.DllList" -BasePath $pathBase

# --------------------------------------------------------------------------------------------------------------
# Handles
# --------------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\05-handles"
New-Directory -Path $pathBase

Invoke-VolatilityModule -ImagePath $Path -FileName "handles" -ModuleName "windows.handles.Handles" -BasePath $pathBase

# --------------------------------------------------------------------------------------------------------------
# CmdLine
# --------------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\06-cmdline"
New-Directory -Path $pathBase

Invoke-VolatilityModule -ImagePath $Path -FileName "cmdline" -ModuleName "windows.cmdline.CmdLine" -BasePath $pathBase

# --------------------------------------------------------------------------------------------------------------
# GetSids
# --------------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\07-getsids"
New-Directory -Path $pathBase

Invoke-VolatilityModule -ImagePath $Path -FileName "getsids" -ModuleName "windows.getsids.GetSIDs" -BasePath $pathBase

# --------------------------------------------------------------------------------------------------------------
# Netstat
# --------------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\08-netstat"
New-Directory -Path $pathBase

Invoke-VolatilityModule -ImagePath $Path -FileName "netstat" -ModuleName "windows.netstat.NetStat" -BasePath $pathBase

# --------------------------------------------------------------------------------------------------------------
# Netscan
# --------------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\09-netscan"
New-Directory -Path $pathBase

Invoke-VolatilityModule -ImagePath $Path -FileName "netscan" -ModuleName "windows.netscan.NetScan" -BasePath $pathBase

# --------------------------------------------------------------------------------------------------------------
# LdrModules
# --------------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\10-ldrmodules"
New-Directory -Path $pathBase

Invoke-VolatilityModule -ImagePath $Path -FileName "ldrmodules" -ModuleName "windows.ldrmodules.LdrModules" -BasePath $pathBase

# --------------------------------------------------------------------------------------------------------------
# Malfind
# --------------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\11-malfind"
New-Directory -Path $pathBase

Invoke-VolatilityModule -ImagePath $Path -FileName "malfind" -ModuleName "windows.malware.malfind.Malfind" -BasePath $pathBase

# --------------------------------------------------------------------------------------------------------------
# SSDT
# --------------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\12-ssdt"
New-Directory -Path $pathBase

Invoke-VolatilityModule -ImagePath $Path -FileName "ssdt" -ModuleName "windows.ssdt" -BasePath $pathBase

# --------------------------------------------------------------------------------------------------------------
# Modules
# --------------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\13-modules"
New-Directory -Path $pathBase

Invoke-VolatilityModule -ImagePath $Path -FileName "modules" -ModuleName "windows.modules.Modules" -BasePath $pathBase

# --------------------------------------------------------------------------------------------------------------
# ModScan
# --------------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\14-modscan"
New-Directory -Path $pathBase

Invoke-VolatilityModule -ImagePath $Path -FileName "modscan" -ModuleName "windows.modscan.ModScan" -BasePath $pathBase

# --------------------------------------------------------------------------------------------------------------
# FileScan
# --------------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\15-filescan"
New-Directory -Path $pathBase

Invoke-VolatilityModule -ImagePath $Path -FileName "filescan" -ModuleName "windows.filescan.FileScan" -BasePath $pathBase

# --------------------------------------------------------------------------------------------------------------
# SvcScan
# --------------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\16-svcscan"
New-Directory -Path $pathBase

Invoke-VolatilityModule -ImagePath $Path -FileName "svcscan" -ModuleName "windows.svcscan.SvcScan" -BasePath $pathBase

# --------------------------------------------------------------------------------------------------------------
# Envars
# --------------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\17-envars"
New-Directory -Path $pathBase

Invoke-VolatilityModule -ImagePath $Path -FileName "envars" -ModuleName "windows.envars.Envars" -BasePath $pathBase

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