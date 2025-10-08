# Invoke-HayabusaForensics

Use it in combination with an KAPE image to parse the evtx files with hayabusa 

## Prerequisites

Make sure that Hayabusa is in PATH

## Usage

`.\Invoke-HayabusaForensics.ps1 -Path [STRING] -Output [STRING] -HayabusaPath [STRING]`

| Option       | Type   | Default                     | Description                             |
| ------------ | ------ | --------------------------- | --------------------------------------- |
| Path         | String | -                           | Path to evtx directory                  |
| Output       | String | .\results\hayabusaforenscis | Path to write Hayabusa Forensics Output |
| HayabusaPath | String | hayabusa.exe                | Path to Hayabusa Executable             |