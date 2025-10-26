#---------------------------------------------------------------------------------------------------------
# Import
#---------------------------------------------------------------------------------------------------------

. $PSScriptRoot\modules\common\New-Directory.ps1
. $PSScriptRoot\modules\doc\New-InvestigationDocumentationSystem.ps1

#---------------------------------------------------------------------------------------------------------
# Program
#---------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host "=== Investigation Documentation ==="
Write-Host "1. Setup"
Write-Host "2. Add System"
Write-Host "3. Fuse IOC"
Write-Host "4. Fuse Timeline"
Write-Host "5. Hash and Create Archive"
$choice = Read-Host "Enter your choice (1-4)"

switch ($choice) {
    '1' { 
        Write-Host ""
        Write-Host "-----"
        Write-Host "Setup"
        Write-Host "-----"
        $p = Read-Host "Enter the path in which investigation documentation shall be created"
        $n = Read-Host "Enter the name of the folder in which investigation documentation shall be created"
        $v = "$p\$n"

        New-Directory -Path $v
        New-Item -Path "$v\overview.md" -ItemType File
        Add-Content -Path "$v\overview.md" -Value "# Overview"
        New-Item -Path "$v\compromised-users.csv" -ItemType File
        Add-Content -Path "$v\compromised-users.csv" -Value "Datetime,Status,Domain,Name,Purpose,Description"
        New-Item -Path "$v\compromised-systems.csv" -ItemType File
        Add-Content -Path "$v\compromised-systems.csv" -Value "Datetime,Status,HostName,IP,MAC,Owner,Purpose,Description"

        New-Directory -Path "$v\systems"
        New-InvestigationDocumentationSystem -Path "$v\systems" -Name "01"
    }
    '2' { 
        Write-Host ""
        Write-Host "----------"
        Write-Host "Add System"
        Write-Host "----------"
        $p = Read-Host "Enter the root path in which new documents for a system to be investigated shall be created"
        $n = Read-Host "Enter the name of the folder in which new documents for a system to be investigated shall be created"

        New-InvestigationDocumentationSystem -Path "$p\systems" -Name $n
    }
    '3' { 
        # Shall fuse ioc csv files of all systems and put it into one ioc csv file within the root directory
        Write-Host "Fuse IOC"
    }
    '4' { 
        # Shall fuse timeline csv files of all systems and put it into one timeline csv file within the root directory
        Write-Host "Fuse Timeline"
    }
    '5' { 
        # Shall create a file containing all hash values of all files in the root directory. Create an archive afterwards.
        Write-Host "Hash and Create Archive"
    }
    default { 
        Write-Host "Invalid choice. Try again." 
    }
}