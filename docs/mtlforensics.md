# Invoke-ExchangeMTLForensics

Parses Exchange Message Tracking Log (MTL) Files and add it into one csv file 

## Usage

`.\Invoke-ExchangeMTLForensics.ps1 -Path [STRING] -Output [STRING] -FileName [STRING] -Filter [STRING]`

| Option   | Type   | Default                      | Description                                                          |
| -------- | ------ | ---------------------------- | -------------------------------------------------------------------- |
| Path     | String | -                            | Path to directory in which Exchange Message Tracking Logs are stored |
| Output   | String | .\results\mtlforensics       | Path to write MTL forensiscs Output                                  |
| FileName | String | message-tracking-log-all.csv | Name of the result file                                              |
| Filter   | String | *.LOG                        | Filter used to identify Message Tracking log data type               |