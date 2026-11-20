# Invoke-ShortcutTargetListing

Lists all lnk files together with their respective target arguments 

## Usage

`.\Invoke-ShortcutTargetListing.ps1 -Path [STRING] -Output [STRING]`

| Option | Type   | Default                           | Description                          |
| ------ | ------ | --------------------------------- | ------------------------------------ |
| Path   | String | -                                 | Path to Windows partition (e.g.: C:) |
| Output | String | .\results\shortcut-target-listing | Path to write lnk files output       |