param(
    $Path,
    $OutputPath = ".\results\listings"
)

.\Invoke-DownloadsListing.ps1 -Path $Path -Output "$OutputPath\01-downloads-listing"
.\Invoke-AutostartListing.ps1 -Path $Path -Output "$OutputPath\02-autostart-listing"
.\Invoke-ShortcutTargetListing.ps1 -Path $Path -Output "$OutputPath\03-shortcut-target-listing"
.\Invoke-TempDirectoriesListing.ps1 -Path $Path -Output "$OutputPath\04-temp-listing"
.\Invoke-ZoneIdentifierListing.ps1 -Path $Path -Output "$OutputPath\05-ads-zoneidentifier-listing"
.\Invoke-ADSListing.ps1 -Path $Path -Output "$OutputPath\06-ads-listing"