# Invoke-FileListings

Creates listings of interesting directories and interesting file types such as:

- All files in Windows Users Download folder
- All files in Windows Users Startup folder
- All files in Windows Users and System temp folder
- All `.lnk` files together with their respective target arguments
- All `Zone Identifiers` from Alternate Data Streams
- All Alternate Data Stream Values

## Prerequisites

Make sure

## Usage

`Invoke-FileListings.ps1 -Path [String] -Output [String]`

| Option | Type   | Default            | Desciption                        |
| ------ | ------ | ------------------ | --------------------------------- |
| Path   | String | -                  | Path to full image                |
| Output | String | .\results\listings | Path to write FileListings output |

## Result

Creates the following folder structure with analysis results saved to `csv` files in the given folders:

```txt
\---listings
    \---01-01-1970_12-00-00Z
        +---01-downloads-listing
        +---02-autostart-listing
        +---03-shortcut-target-listing
        +---04-temp-listing
        +---05-ads-zoneidentifier-listing
        +---06-ads-listing