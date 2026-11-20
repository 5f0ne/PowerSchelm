# Invoke-Bstrings

Uses `bstrings` to collect information from a binary source.

## Prerequisites

Make sure that EZTools is available in `PATH`.

## Usage

`.\Invoke-Bstrings.ps1 -Path [STRING] -Output [STRING] -StringLength [INT] -ApplyBuildinRegex [BOOL] -BstringsPath [STRING]`

| Option            | Type   | Default            | Description                                            |
| ----------------- | ------ | ------------------ | ------------------------------------------------------ |
| Path              | String | -                  | Path to binary source                                  |
| Output            | String | .\results\bstrings | Path to write Bstrings Output                          |
| StringLength      | Int    | 10                 | Length of strings extracted by bstrings                |
| ApplyBuildinRegex | Bool   | $False             | If true, applies all built-in BStrings regex           |
| BstringsPath      | String | $false             | If true, an archive of the files is created and hashed |

## Result

Creates the following folder structure with analysis results saved to `txt` files in the given folders:

```txt
\---bstrings
    \---01-01-1970_12-00-00Z
        +---01-all
        +---02-regex
        +---99-error
```