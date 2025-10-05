# Invoke-Kape

Collects files with `Kape`.

## Usage

`.\Invoke-Kape.ps1 -Path [STRING] -Output [STRING] -StringLength [Int] -ArchiveName [STRING] -Archive [Bool]`

| Option      | Type   | Default                                                                                                                                                                   | Description                                            |
| ----------- | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------ |
| Path        | String | -                                                                                                                                                                         | Path from which Kape shall collect                     |
| OutputPath  | String | .\results\ramforensics                                                                                                                                                    | Path to write RamForensics Output                      |
| KapePath    | Int    | kape.exe                                                                                                                                                                  | Path to Kape Executable                                |
| KapeTargets | String | !BasicCollection,!SANS_Triage,KapeTriage,ServerTriage,CombinedLogs,IRCClients,RecycleBin,RemoteAdmin,SOFELK,SQLiteDatabases,TorrentClients,RecentFileCache,StartupFolders | Kape Collection Targets                                |