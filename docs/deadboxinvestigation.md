# Invoke-DeadboxInvestigation

Starts Invoke-EZToolsForensics, Invoke-HayabusaForensics, Invoke-MftTimeline, Invoke-UsnJrnlForensics and Invoke-Autoruns on a given KAPE image.  

## Usage

`.\Invoke-DeadboxInvestigation.ps1 -Path [STRING] -Output [STRING]`

| Option | Type   | Default | Description                               |
| ------ | ------ | ------- | ----------------------------------------- |
| Path   | String | -       | Path to KAPE image (e.g.: "E:\C")         |
| Output | String | .       | Path to write DeadboxInvestigation Output |