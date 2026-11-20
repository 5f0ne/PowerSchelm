# Invoke-LiveWindowsEventCollection

Collects Windows Events from a live system 

## Usage

`.\Invoke-LiveWindowsEventCollection.ps1 -Path [STRING] -Output [STRING]`

| Option      | Type   | Default                            | Description                                   |
| ----------- | ------ | ---------------------------------- | --------------------------------------------- |
| Output      | String | .\results\windows-event-collection | Path to write windows event collection output |
| MinutesBack | Int    | 10                                 | Time back to collect events                   |