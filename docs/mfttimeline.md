# Invoke-MftTimeline

Use it to generate a Timeline with MFTECmd and mactime

## Prerequisites

Make sure that MFTECmd, [perl](https://strawberryperl.com/) and mactime is in PATH

## Usage

`.\Invoke-MftTimeline.ps1 -Path [STRING] -Output [STRING] -DriveLetter [STRING] -MfteCmdPath [STRING] -PerlPath [STRING] -TskPathWord [STRING]`

| Option      | Type   | Default          | Description                                                             |
| ----------- | ------ | ---------------- | ----------------------------------------------------------------------- |
| Path        | String | -                | Path to directory in which all executables will be checked recursively  |
| Output      | String | .\results\mft-tl | Path to write timeline output                                           |
| DriveLetter | String | C                | Drive letter used by mactime                                            |
| MfteCmdPath | String | MFTECmd.exe      | Path to MFTECmd executable                                              |
| PerlPath    | String | perl.exe         | Path to perl executable                                                 |
| TskPathWord | String | SleuthKit        | Unique word in the path to TSK to determine the correct value from PATH |