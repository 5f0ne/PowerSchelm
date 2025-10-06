# Invoke-Autoruns

Get ASEP with `autoruns` of an image.

## Prerequisites

- Make sure to put `autoruns` and `reg` in PATH
- Mount the image with temporary read and write permissions since autorunsc need to write to the registry hives

## Usage

`.\Invoke-Autoruns.ps1 -Path [STRING] -Output [STRING] -AutorunscPath [STRING]`

| Option        | Type   | Default                       | Description                                             |
| ------------- | ------ | ----------------------------- | ------------------------------------------------------- |
| Path          | String | -                             | Path of kape image on which autorunsc shall be executed |
| Output        | String | .\results\autorunsc           | Path to write Autorunsc Output                          |
| AutorunscPath | String | autorunsc.exe                 | Path to Kape Executable                                 |