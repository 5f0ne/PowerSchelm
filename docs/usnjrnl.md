# Invoke-UsnJrnlForensics

Use it to parse $UsnJrnl with MFTECmd  

## Prerequisites

Make sure that MFTECmd is in PATH

## Usage

`.\Invoke-UsnJrnlForensics.ps1 -JPath [STRING] -MftPath [STRING] -Output [STRING] -MfteCmdPath [STRING]`

| Option      | Type   | Default               | Description                            |
| ----------- | ------ | --------------------- | -------------------------------------- |
| JPath       | String | -                     | Path to $J file                        |
| MftPath     | String | -                     | Path to $MFT file                      |
| Output      | String | .\results\mft-usnjrnl | Path to write UsnJrnl Forensics Output |
| MfteCmdPath | String | sigcheck.exe          | Path to Sigcheck Executable            |