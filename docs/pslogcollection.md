# Invoke-PSLogCollection

Collects PowerShell Transcript and ReadLine log files by searching for `PowerShell_transcript*.txt` and `*_history.txt`. 

## Usage

`.\Invoke-PSLogCollection.ps1 -Path [STRING] -Output [STRING]`

| Option | Type   | Default                   | Description                                                                 |
| ------ | ------ | ------------------------- | --------------------------------------------------------------------------- |
| Path   | String | -                         | Path to folder structure which shall be recursively search for PS log files |
| Output | String | .\results\pslogcollection | Path to write PSLogCollection Output                                        |