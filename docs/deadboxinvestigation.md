# Invoke-DeadboxInvestigation

Starts Invoke-EZToolsForensics, Invoke-HayabusaForensics, Invoke-PSLogCollection, Invoke-MftTimeline, Invoke-UsnJrnlForensics and Invoke-Autoruns on a given KAPE image.  

## Usage

`.\Invoke-DeadboxInvestigation.ps1 -KapePath [STRING] -Output [STRING]`

| Option   | Type   | Default | Description                               |
| -------- | ------ | ------- | ----------------------------------------- |
| KapePath | String | -       | Path to KAPE image (e.g.: "E:\C")         |
| Output   | String | .       | Path to write DeadboxInvestigation Output |