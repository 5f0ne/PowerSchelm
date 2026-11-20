# Invoke-AutostartListing

Lists all files in Windows Users Startup folder 

## Usage

`.\Invoke-AutostartListing.ps1 -Path [STRING] -Output [STRING]`

| Option | Type   | Default                     | Description                          |
| ------ | ------ | --------------------------- | ------------------------------------ |
| Path   | String | -                           | Path to Windows partition (e.g.: C:) |
| Output | String | .\results\autostart-listing | Path to write autostart files output |