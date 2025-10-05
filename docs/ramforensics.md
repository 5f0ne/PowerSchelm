# Invoke-RamForensics

Uses `bstrings` and `Volatility` to collect information from ram images. 

## Prerequisites

Make sure that EZTools and Volatility are in PATH.

## Usage

`.\Invoke-RamForensics.ps1 -Path [STRING] -Output [STRING] -StringLength [Int] -ArchiveName [STRING] -Archive [Bool]`

| Option       | Type   | Default                | Description                                            |
| ------------ | ------ | ---------------------- | ------------------------------------------------------ |
| Path         | String | -                      | Path to RAM image                                      |
| Output       | String | .\results\ramforensics | Path to write RamForensics Output                      |
| StringLength | Int    | 10                     | Length of strings extracted by bstrings                |
| ArchiveName  | String | ramforensics           | Name of the archive                                    |
| Archive      | Bool   | $false                 | If true, an archive of the files is created and hashed |

## Result

Creates the following folder structure with analysis results saved to `txt` and `csv` files in the given folders:

```txt
\---ramforensics
    \---01-01-1970_12-00-00Z
        +---01-bstrings
        +---02-processes
        +---03-scheduled-tasks
        +---04-dlllist
        +---05-handles
        +---06-cmdline
        +---07-getsids
        +---08-netstat
        +---09-netscan
        +---10-ldrmodules
        +---11-malfind
        +---12-ssdt
        +---13-modules
        +---14-modscan
        +---15-filescan
        +---16-svcscan
        +---17-envars
        \---99-error
```