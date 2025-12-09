param(
    $KapePath,
    $Output="."
)


# EZToolsForensics
.\Invoke-EZToolsForensics.ps1 -KapePath $KapePath -Output "$Output\results\eztoolsforensics"

# HayabusaForensics
.\Invoke-HayabusaForensics.ps1 -Path $KapePath -Output "$Output\results\hayabusaforensics" 

# PSLogCollection
.\Invoke-PSLogCollection.ps1 -Path $KapePath -Output "$Output\results\pslogcollection"

# MftTimeline
.\Invoke-MftTimeline.ps1 -Path "$KapePath\`$MFT" -Output "$Output\results\mft-tl" 

# UsnJrnl
.\Invoke-UsnJrnlForensics.ps1 -JPath "$KapePath\`$Extend\`$J" -MftPath "$KapePath\`$MFT" -Output "$Output\results\mft-usnjrnl" 

# Autorunsc
.\Invoke-Autoruns.ps1 -Path $KapePath -Output "$Output\results\autorunsc" 