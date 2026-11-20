<# 
Prerequisites:
pip install volatility3
#>
param($ErrorActionPreference = "SilentlyContinue", 
    # Path to memory dumps
    [string]$Path,
    # Output path
    [string]$Output = ".\results\vol3",
    [string]$VolPath ="vol.exe"
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
    Start-Process -FilePath $VolPath -ArgumentList "-f $Path -r pretty $ModuleName" -RedirectStandardOutput $tmp -RedirectStandardError $e -NoNewWindow -Wait
    # Removes the first line from volatility output
    (Get-Content $tmp | Select-Object -Skip 1) | Set-Content $p -Encoding utf8
    Import-Csv -Path $p -Delimiter "|" | Select-object * | Export-Csv $c -NoTypeInformation
    Remove-Item -LiteralPath $tmp -Force
}

#---------------------------------------------------------------------------------------------------------
# Import
#---------------------------------------------------------------------------------------------------------

. $PSScriptRoot\modules\common\New-Directory.ps1
. $PSScriptRoot\modules\common\Export-ExecutionTime.ps1
. $PSScriptRoot\modules\common\Export-FileHashes.ps1

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
# Volatility3
# --------------------------------------------------------------------------------------------------------------
# Process
# --------------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\01-processes"
New-Directory -Path $pathBase

Invoke-VolatilityModule -ImagePath $Path -FileName "pslist" -ModuleName "windows.pslist.PsList" -BasePath $pathBase
Invoke-VolatilityModule -ImagePath $Path -FileName "pstree" -ModuleName "windows.pstree.PsTree" -BasePath $pathBase
Invoke-VolatilityModule -ImagePath $Path -FileName "psscan" -ModuleName "windows.psscan.PsScan" -BasePath $pathBase
Invoke-VolatilityModule -ImagePath $Path -FileName "psxview" -ModuleName "windows.malware.psxview.PsXView" -BasePath $pathBase

# --------------------------------------------------------------------------------------------------------------
# ScheduledTasks
# --------------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\02-scheduled-tasks"
New-Directory -Path $pathBase

Invoke-VolatilityModule -ImagePath $Path -FileName "scheduled-tasks" -ModuleName "windows.registry.scheduled_tasks.ScheduledTasks" -BasePath $pathBase

# --------------------------------------------------------------------------------------------------------------
# DLLs
# --------------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\03-dlllist"
New-Directory -Path $pathBase

Invoke-VolatilityModule -ImagePath $Path -FileName "dlllist" -ModuleName "windows.dlllist.DllList" -BasePath $pathBase

# --------------------------------------------------------------------------------------------------------------
# Handles
# --------------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\04-handles"
New-Directory -Path $pathBase

Invoke-VolatilityModule -ImagePath $Path -FileName "handles" -ModuleName "windows.handles.Handles" -BasePath $pathBase

# --------------------------------------------------------------------------------------------------------------
# CmdLine
# --------------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\05-cmdline"
New-Directory -Path $pathBase

Invoke-VolatilityModule -ImagePath $Path -FileName "cmdline" -ModuleName "windows.cmdline.CmdLine" -BasePath $pathBase

# --------------------------------------------------------------------------------------------------------------
# GetSids
# --------------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\06-getsids"
New-Directory -Path $pathBase

Invoke-VolatilityModule -ImagePath $Path -FileName "getsids" -ModuleName "windows.getsids.GetSIDs" -BasePath $pathBase

# --------------------------------------------------------------------------------------------------------------
# Netstat
# --------------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\07-netstat"
New-Directory -Path $pathBase

Invoke-VolatilityModule -ImagePath $Path -FileName "netstat" -ModuleName "windows.netstat.NetStat" -BasePath $pathBase

# --------------------------------------------------------------------------------------------------------------
# Netscan
# --------------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\08-netscan"
New-Directory -Path $pathBase

Invoke-VolatilityModule -ImagePath $Path -FileName "netscan" -ModuleName "windows.netscan.NetScan" -BasePath $pathBase

# --------------------------------------------------------------------------------------------------------------
# LdrModules
# --------------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\09-ldrmodules"
New-Directory -Path $pathBase

Invoke-VolatilityModule -ImagePath $Path -FileName "ldrmodules" -ModuleName "windows.ldrmodules.LdrModules" -BasePath $pathBase

# --------------------------------------------------------------------------------------------------------------
# Malfind
# --------------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\10-malfind"
New-Directory -Path $pathBase

Invoke-VolatilityModule -ImagePath $Path -FileName "malfind" -ModuleName "windows.malware.malfind.Malfind" -BasePath $pathBase

# --------------------------------------------------------------------------------------------------------------
# SSDT
# --------------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\11-ssdt"
New-Directory -Path $pathBase

Invoke-VolatilityModule -ImagePath $Path -FileName "ssdt" -ModuleName "windows.ssdt" -BasePath $pathBase

# --------------------------------------------------------------------------------------------------------------
# Modules
# --------------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\12-modules"
New-Directory -Path $pathBase

Invoke-VolatilityModule -ImagePath $Path -FileName "modules" -ModuleName "windows.modules.Modules" -BasePath $pathBase

# --------------------------------------------------------------------------------------------------------------
# ModScan
# --------------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\13-modscan"
New-Directory -Path $pathBase

Invoke-VolatilityModule -ImagePath $Path -FileName "modscan" -ModuleName "windows.modscan.ModScan" -BasePath $pathBase

# --------------------------------------------------------------------------------------------------------------
# FileScan
# --------------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\14-filescan"
New-Directory -Path $pathBase

Invoke-VolatilityModule -ImagePath $Path -FileName "filescan" -ModuleName "windows.filescan.FileScan" -BasePath $pathBase

# --------------------------------------------------------------------------------------------------------------
# SvcScan
# --------------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\15-svcscan"
New-Directory -Path $pathBase

Invoke-VolatilityModule -ImagePath $Path -FileName "svcscan" -ModuleName "windows.svcscan.SvcScan" -BasePath $pathBase

# --------------------------------------------------------------------------------------------------------------
# Envars
# --------------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\16-envars"
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