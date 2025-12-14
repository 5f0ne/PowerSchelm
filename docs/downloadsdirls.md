# Invoke-DownloadsListing

Lists all files in Windows Users Downloads folders 

## Usage

`.\Invoke-DownloadsListing.ps1 -Path [STRING] -Output [STRING]`

| Option | Type   | Default                     | Description                                 |
| ------ | ------ | --------------------------- | ------------------------------------------- |
| Path   | String | -                           | Path to Windows system partition (e.g.: C:) |
| Output | String | .\results\downloads-listing | Path to write DownloadFiles output          |