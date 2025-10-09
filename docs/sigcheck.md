# Invoke-Sigcheck

Use it to check executables with sigcheck  

## Prerequisites

Make sure that Sigcheck is in PATH

## Usage

`.\Invoke-Sigcheck.ps1 -Path [STRING] -Output [STRING] -SigcheckPath [STRING]`

| Option       | Type   | Default            | Description                                                            |
| ------------ | ------ | ------------------ | ---------------------------------------------------------------------- |
| Path         | String | -                  | Path to directory in which all executables will be checked recursively |
| Output       | String | .\results\sigcheck | Path to write Sigcheck Output                                          |
| SigcheckPath | String | sigcheck.exe       | Path to Sigcheck Executable                                            |