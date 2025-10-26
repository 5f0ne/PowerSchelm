function New-InvestigationDocumentationSystem {
    param (
        $Path,
        $Name
    )

    $p = "$Path\$Name"

    New-Directory -Path $p

    New-Item -Path "$p\tl.csv" -ItemType File
    Add-Content -Path "$p\tl.csv" -Value "Timestamp,System,Source,Description"

    New-Item -Path "$p\ioc.csv" -ItemType File
    Add-Content -Path "$p\ioc.csv" -Value "Value,Type,System,Source,Description"

    New-Item -Path "$p\notes.md" -ItemType File
    Add-Content -Path "$p\notes.md" -Value "# Notes"
}