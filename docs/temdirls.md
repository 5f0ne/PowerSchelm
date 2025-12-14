# Invoke-TempDirectoriesListing

Lists all files in Windows Users and System Temp folders 

## Usage

`.\Invoke-TempDirectoriesListing.ps1 -Path [STRING] -Output [STRING]`

| Option | Type   | Default              | Description                                 |
| ------ | ------ | -------------------- | ------------------------------------------- |
| Path   | String | -                    | Path to Windows system partition (e.g.: C:) |
| Output | String | .\results\temp-files | Path to write TempFiles output              |