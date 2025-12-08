# Invoke-Kape

Collects files with `Kape`.

## Usage

`.\Invoke-Kape.ps1 -Path [STRING] -Output [STRING] -KapePath [STRING] -KapeTargets [STRING]`

| Option         | Type   | Default                                                                                                                                                                                    | Description                                        |
| -------------- | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------------------------------------------------- |
| Path           | String | -                                                                                                                                                                                          | Path from which Kape shall collect                 |
| OutputPath     | String | .\results\ramforensics                                                                                                                                                                     | Path to write RamForensics Output                  |
| Vhdx           | Bool   | False                                                                                                                                                                                      | If true, vhdx container will be created and zipped |
| VhdxIdentifier | String | kape-collection                                                                                                                                                                            | Identifier name for vhdx container                 |
| KapePath       | String | kape.exe                                                                                                                                                                                   | Path to Kape Executable                            |
| KapeTargets    | String | !BasicCollection,!SANS_Triage,KapeTriage,ServerTriage,CombinedLogs,IRCClients,RecycleBin,RemoteAdmin,SOFELK,SQLiteDatabases,TorrentClients,RecentFileCache,StartupFolders,CloudStorage_All | Kape Collection Targets                            |