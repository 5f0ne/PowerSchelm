function New-InvestigationDocumentationSystem {
    param (
        $Path,
        $Name
    )

    $p = "$Path\$Name"

    New-Directory -Path $p


    $tlDir = "$p\tl"
    New-Directory -Path $tlDir
    New-Item -Path "$tlDir\tl.csv" -ItemType File
    Add-Content -Path "$tlDir\tl.csv" -Value "Timestamp,System,Source,Description"

    $iocDir = "$p\ioc"
    New-Item -Path "$iocDir\ioc.csv" -ItemType File
    Add-Content -Path "$iocDir\ioc.csv" -Value "Source,Type,Value,Description"

    $loginDir = "$p\login"
    New-Item -Path "$loginDir\acc.csv" -ItemType File
    Add-Content -Path "$loginDir\acc.csv" -Value "Target,Count"
    New-Item -Path "$loginDir\ip.csv" -ItemType File
    Add-Content -Path "$loginDir\ip.csv" -Value "IP,Count"

    New-Item -Path "$p\notes.md" -ItemType File
    Add-Content -Path "$p\notes.md" -Value "# Notes"
}