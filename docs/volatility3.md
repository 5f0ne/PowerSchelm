# Invoke-Volatility3

Uses `volatility3` to collect information from a ram image

## Prerequisites

Make sure that `volatility3` is installed via `python`  and that `vol.exe` is available via `PATH`.

```py
pip install volatility3
```

## Usage

`.\Invoke-Volatility3.ps1 -Path [String] -Output [String] -VolPath [String]`

| Option  | Type   | Default        | Description                     |
| ------- | ------ | -------------- | ------------------------------- |
| Path    | String | -              | Path to binary source           |
| Output  | String | .\results\vol3 | Path to write Volatility Output |
| VolPath | String | vol.exe        | Path to volatility exe          |

## Result

Create the following folder structure with analysis results saved to `txt` files in the given folders:

```txt
\---vol3
    \---01-01-1970_12-00-00Z
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
        +---99-error
```