# Invoke-EZToolsForensics

Use it in combination with an KAPE image to parse artifacts with [EZTools](https://ericzimmerman.github.io).

## Prerequisites

Make sure that EZTools are in PATH.

## Usage

`.\Invoke-EZToolsForensics.ps1 -KapePath [STRING] -Output [STRING] -EZToolsPathWord [STRING] -RebPath [STRING] -ArchiveName [String] -Archive [Bool]`

| Option          | Type   | Default                    | Description                                                                            |
| --------------- | ------ | -------------------------- | -------------------------------------------------------------------------------------- |
| KapePath        | String | -                          | Path to kape image                                                                     |
| Output          | String | .\results\eztoolsforensics | Path to write EZToolsForensics Output                                                  |
| EZToolsPathWord | String | Get-ZimmermanTools         | Unique word in the path to the EZTools to determine the correct value from PATH        |
| RebPath         | String | ""                         | Path to RebFiles. If no RebPath is provided, the path to the RebFiles in RECmd is used |
| ArchiveName     | String | ramforensics               | Name of the archive                                                                    |
| Archive         | Bool   | $false                     | If true, an archive of the files is created and hashed                                 |

## Result

Creates the following folder structure with analysis results saved to `txt` and `csv` files in the given folders:

```txt
\---eztoolsforensics
    \---01-01-1970_12-00-00Z
        +---01-prefetch
        +---02-amcache
        +---03-shimcache
        +---04-srum
        +---05-sqlite
        +---06-jumplists
        |   \---01-dump
        +---07-lnk
        |   +---01-system
        |   \---02-jle-dump
        +---08-recycle-bin
        +---09-recent-file-cache
        +---10-shell-bags
        +---11-sum
        +---12-win10-tl
        +---13-registry
        +---14-mft
        +---15-evtx
        |   \---01-data
        \---99-error
```