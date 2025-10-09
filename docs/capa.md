# Invoke-Capa

Use it to check executables with capa  

## Prerequisites

Make sure that capa is in PATH

## Usage

`.\Invoke-Capa.ps1 -Path [STRING] -Output [STRING] -CapaPath [STRING]`

| Option   | Type   | Default        | Description                               |
| -------- | ------ | -------------- | ----------------------------------------- |
| Path     | String | -              | Path to executable which shall be checked |
| Output   | String | .\results\capa | Path to write capa Output                 |
| CapaPath | String | capa.exe       | Path to capa Executable                   |