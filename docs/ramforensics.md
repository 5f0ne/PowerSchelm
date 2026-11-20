# Invoke-RamForensics

Uses `bstrings` and `Volatility` to collect information from ram images. 

## Prerequisites

Make sure that `EZTools` and `Volatility` are in `PATH`.

## Usage

`.\Invoke-RamForensics.ps1 -Path [STRING] -Output [STRING] -StringLength [Int] -ArchiveName [STRING] -Archive [Bool]`

| Option             | Type   | Default                | Description                                            |
| ------------------ | ------ | ---------------------- | ------------------------------------------------------ |
| Path               | String | -                      | Path to RAM image                                      |
| Output             | String | .\results\ramforensics | Path to write RamForensics Output                      |
| StringLength       | Int    | 10                     | Length of strings extracted by bstrings                |
| ArchiveName        | String | ramforensics           | Name of the archive                                    |
| Archive            | Bool   | $false                 | If true, an archive of the files is created and hashed |
| ApplyBstringsRegex | Bool   | $false                 | If true, bstrings with Regex search is activated       |

## Result

Creates the following folder structure with analysis results saved to `txt` and `csv` files in the given folders:

```txt
\---ramforensics
    \---01-01-1970_12-00-00Z
        +---01-bstrings
            +---01-all
            +---02-regex
            +---99-error
        +---02-vol3
            +---01-processes
            +---02-scheduled-tasks
            +---03-dlllist
            +---04-handles
            +---05-cmdline
            +---06-getsids
            +---07-netstat
            +---08-netscan
            +---09-ldrmodules
            +---10-malfind
            +---11-ssdt
            +---12-modules
            +---13-modscan
            +---14-filescan
            +---15-svcscan
            +---16-envars
            \---99-error
        \---99-error
```