# EZToolsForensics
# ---
# Zimmerman Tools need to be available in path
# ---

param($ErrorActionPreference = "SilentlyContinue",
    $KapePath, # -KapePath "F:\Path\to\kape\dir\E"
    $Prefetch = "Windows\Prefetch",
    $AmCache = "Windows\appcompat\Programs\Amcache.hve",
    $ShimCache = "Windows\System32\config\SYSTEM",
    $Srum = "Windows\System32",
    $Registry = "Windows\System32",
    $RegistryUser = "Users",
    $Evtx = "Windows\System32\Winevt\Logs",
    $Output = ".\results\eztoolsforensics",
    $ArchiveName = "eztoolsforensics",
    $EZToolsPathWord = "Get-ZimmermanTools",
    $RebPath = "",
    $Archive = $false
)

#---------------------------------------------------------------------------------------------------------
# Function
#---------------------------------------------------------------------------------------------------------

function Invoke-EZTool {
    param(
        $Name,
        $Executable,
        $Target,
        $Output,
        $IsDir = $false,
        $Params
    )

    if ($IsDir) {
        $a = "-d $Target --csv $Output $Params"
        Start-Process -FilePath "$Executable" -ArgumentList $a -Wait -NoNewWindow -RedirectStandardOutput "$Output\$Name-log.txt" -RedirectStandardError "$Output\$Name-error.txt"
    }
    else {
        $a = "-f $Target --csv $Output $Params"
        Start-Process -FilePath "$Executable" -ArgumentList $a -Wait -NoNewWindow -RedirectStandardOutput "$Output\$Name-log.txt" -RedirectStandardError "$Output\$Name-error.txt"
    }
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

New-Directory -Path $basePath

$EZPath = ""

$paths = $env:PATH -Split ';'
foreach ($path in $paths) {
    if ($path.Contains($EZToolsPathWord)) {  
        $EZPath = $path
        break
    }
}

if($RebPath -eq ""){
    $RebPath = "$EZPath\RECmd\BatchExamples"
}

#---------------------------------------------------------------------------------------------------------
# Prefetch (PECmd)
#---------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\01-prefetch"
New-Directory -Path $pathBase
$target = "$KapePath\$Prefetch"

Invoke-EZTool -Name "pecmd" -Executable "PECmd.exe" -Target $target -Output $pathBase -IsDir $true

#---------------------------------------------------------------------------------------------------------
# AmCache (AmCacheParser)
#---------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\02-amcache"
New-Directory -Path $pathBase
$target = "$KapePath\$AmCache"

Invoke-EZTool -Name "amcache" -Executable "AmcacheParser.exe" -Target $target -Output $pathBase

#---------------------------------------------------------------------------------------------------------
# ShimCache (AppCompatCacheParser)
#---------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\03-shimcache"
New-Directory -Path $pathBase
$target = "$KapePath\$ShimCache"

Invoke-EZTool -Name "shimcache" -Executable "AppCompatCacheParser.exe" -Target $target -Output $pathBase

#---------------------------------------------------------------------------------------------------------
# SRUM (SrumECmd)
#---------------------------------------------------------------------------------------------------------

# 5.) Parse SRUM (SrumECmd)

$pathBase = "$basePath\04-srum"
New-Directory -Path $pathBase
$target = "$KapePath\$Srum"

Invoke-EZTool -Name "srum" -Executable "SrumECmd.exe" -Target $target -Output $pathBase -IsDir $true

#---------------------------------------------------------------------------------------------------------
# SQLite (SQLECmd)
#---------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\05-sqlite"
New-Directory -Path $pathBase
$target = $KapePath

Invoke-EZTool -Name "sqlite" -Executable "SQLECmd\SQLECmd.exe" -Target $target -Params "--hunt true --maps $EZPath\SQLECmd\Maps" -Output $pathBase -IsDir $true

#---------------------------------------------------------------------------------------------------------
# Jump Lists (JLECmd)
#---------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\06-jumplists"
$dumpDir = "$pathBase\01-dump"
New-Directory -Path $pathBase
New-Directory -Path $dumpDir
$target = $KapePath

Invoke-EZTool -Name "jumplists" -Executable "JLECmd.exe" -Target $target -Params "--fd --dumpTo $dumpDir" -Output $pathBase -IsDir $true

#---------------------------------------------------------------------------------------------------------
# LNK (LECmd)
#---------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\07-lnk"
New-Directory -Path $pathBase


$systemDir = "$pathBase\01-system"
New-Directory -Path $systemDir
$target = $KapePath
Invoke-EZTool -Name "lecmd" -Executable "LECmd.exe" -Target $target -Output $systemDir -Params "--mp" -IsDir $true


$jleDir = "$pathBase\02-jle-dump"
New-Directory -Path $jleDir
$target = $dumpDir
Invoke-EZTool -Name "lecmd" -Executable "LECmd.exe" -Target $target -Output $jleDir -Params "--mp" -IsDir $true

#---------------------------------------------------------------------------------------------------------
# Recycle Bin (RBCmd)
#---------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\08-recycle-bin"
New-Directory -Path $pathBase

$target = "$KapePath\`$Recycle.Bin"

Invoke-EZTool -Name "rbcmd" -Executable "RBCmd.exe" -Target $target -Output $pathBase -IsDir $true

#---------------------------------------------------------------------------------------------------------
# RecentFileCache (RecentFileCacheParser)
#---------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\09-recent-file-cache"
New-Directory -Path $pathBase

$target = "$KapePath\$AmCache"

Invoke-EZTool -Name "recentfilecache" -Executable "RecentFileCacheParser.exe" -Target $target -Output $pathBase

#---------------------------------------------------------------------------------------------------------
# Shell Bags (SBECmd)
#---------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\10-shell-bags"
New-Directory -Path $pathBase

$target = $KapePath

Invoke-EZTool -Name "shellbags" -Executable "SBECmd.exe" -Target $target -Output $pathBase -IsDir $true

#---------------------------------------------------------------------------------------------------------
# SUM (SumECmd)
#---------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\11-sum"
New-Directory -Path $pathBase

$target = $KapePath

Invoke-EZTool -Name "sum" -Executable "SumECmd.exe" -Target $target -Output $pathBase -IsDir $true

#---------------------------------------------------------------------------------------------------------
# Windows10 Timeline (WxTCmd)
#---------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\12-win10-tl"
New-Directory -Path $pathBase

$target = "$KapePath\Users"

Get-ChildItem -Path $target -Recurse -File -Filter 'ActivitiesCache.db' -Force | ForEach-Object {
    Write-Host $_.FullName
    Invoke-EZTool -Name "wxt" -Executable "WxTCmd.exe" -Target $_.FullName -Output $pathBase 
}

#---------------------------------------------------------------------------------------------------------
# Registry (RECmd)
#---------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\13-registry"
New-Directory -Path $pathBase

Get-ChildItem -Path $RebPath -Filter *.reb | ForEach-Object {
    $name = $_.BaseName
    $dir = "$pathBase\$name"
    New-Directory -Path $dir

    $systemDir = "$dir\01-system"
    New-Directory -Path $systemDir
    $target = "$KapePath\$Registry"
    Invoke-EZTool -Name "recmd" -Executable "RECmd\RECmd.exe" -Target $target -Output $systemDir -Params "--bn $($_.FullName)" -IsDir $true

    $userDir = "$dir\02-user"
    New-Directory -Path $userDir
    $target = "$KapePath\$RegistryUser"
    Invoke-EZTool -Name "recmd" -Executable "RECmd\RECmd.exe" -Target $target -Output $userDir -Params "--bn $($_.FullName)" -IsDir $true
}

#---------------------------------------------------------------------------------------------------------
# MFT (MFTECmd)
#---------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\14-mft"
New-Directory -Path $pathBase
$target = "$KapePath\$`MFT"

Invoke-EZTool -Name "mft" -Executable "MFTECmd.exe" -Target $target -Output $pathBase

#---------------------------------------------------------------------------------------------------------
# Evtx (EvtxECmd)
#---------------------------------------------------------------------------------------------------------

$pathBase = "$basePath\15-evtx"
$evtxDir = "$pathBase\01-data"
New-Directory -Path $pathBase
New-Directory -Path $evtxDir

$target = "$KapePath\$Evtx"

# Process each EVTX and write one CSV per file
Get-ChildItem -Path $target -Filter *.evtx -Recurse | ForEach-Object {
    $name = $_.BaseName
    $dir = "$evtxDir\$name"
    New-Directory -Path $dir
    Invoke-EZTool -Name "evtx" -Executable "EvtxECmd\EvtxECmd.exe" -Target $_.FullName -Output $dir 
}

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