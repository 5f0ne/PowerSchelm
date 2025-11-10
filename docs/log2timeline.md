# Invoke-Log2TImeline

Creates a supertimeline with log2timeline / plaso

## Prerequisites

This script is tested with [SIFT](https://www.sans.org/tools/sift-workstation). Make sure that PowerShell is
available as `pwsh` as well as `log2timeline` and `psort`.

## Usage

`.\Invoke-Log2Timeline.ps1 -Path [STRING] -Output [STRING] -PSortOutput [STRING]`

| Option      | Type   | Default                | Description                                                                           |
| ----------- | ------ | ---------------------- | ------------------------------------------------------------------------------------- |
| Path        | String | -                      | Path to target from which supertimeline shall be created: e.g. .vmdk, Kape collection |
| Output      | String | .\results\log2timeline | Path to write log2timeline and psort output                                           |
| PSortOutput | String | l2tcsv                 | Output Mode for psort: l2tcsv, csv, dynamic                                           |