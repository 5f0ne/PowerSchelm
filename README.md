# PowerSchelm

Powershell Data Aquisition and Analysis Framework (PD2AF) - Different Powershell Tools for Data Aquisition and Analysis


## Setup

Please follow the instructions [here](/docs/setup.md)

## Overview


| Name                                                         | Description                                                                                                                                     |
| ------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| [Invoke-DeadboxInvestigation](/docs/deadboxinvestigation.md) | Starts Invoke-EZToolsForensics, Invoke-HayabusaForensics, Invoke-MftTimeline, Invoke-UsnJrnlForensics and Invoke-Autoruns on a given KAPE image |
| [Invoke-Kape](/docs/kape.md)                                 | Collects files with KAPE                                                                                                                        |
| [Invoke-LiveBoxForensics](/docs/liveboxforensics.md)         | Use it if you have a running system and you are interested in evidence collection                                                               |
| [Invoke-EZToolsForensics](/docs/eztoolsforensics.md)         | Use it in combination with an KAPE image to parse artifacts with EZTools                                                                        |
| [Invoke-RamForensics](/docs/ramforensics.md)                 | Uses bstrings and Volatility to collect information from ram images                                                                             |
| [Invoke-Autoruns](/docs/autorunsc.md)                        | Uses autorunsc to collect ASEP from an offline image                                                                                            |
| [Invoke-HayabusaForensics](/docs/hayabusaforensics.md)       | Use it in combination with an KAPE image to parse the evtx files with hayabusa                                                                  |
| [Invoke-Sigcheck](/docs/sigcheck.md)                         | Use it to check executables with sigcheck                                                                                                       |
| [Invoke-Capa](/docs/capa.md)                                 | Use it to check executables with capa                                                                                                           |
| [Invoke-MftTimeline](/docs/mfttimeline.md)                   | Use it to generate a timeline with MFTECmd and mactime                                                                                          |
| [Invoke-UsnJrnlForensics](/docs/usnjrnl.md)                  | Use it to parse $UsnJrnl with MFTECmd                                                                                                           |
| [Invoke-ExchangeMTLForensics](/docs/mtlforensics.md)         | Parses Exchange Message Tracking Log (MTL) Files and add it into one csv file                                                                   |
| [Invoke-MailHeaderForensics](/docs/mailheaderforensics.md)   | Parses files which includes mail headers and provides a list with metadata                                                                      |
| [Invoke-Log2Timeline](/docs/log2timeline.md)                 | Creates a supertimeline with log2timeline/plaso                                                                                                 |
| [Invoke-PSLogCollection](/docs/pslogcollection.md)           | Collects PowerShell Transcript and ReadLine log files                                                                                           |
| [Invoke-Bstrings](/docs/bstrings.md)                         | Use bstrings to collect information from a binary source                                                                                        |
| [Invoke-Volatility3](/docs/volatility3.md)                   | Use volatility3 to collect information from a ram image                                                                                         |
| [Invoke-FileListings](/docs/filelistings.md)                 | Creates file listings for interesting directories                                                                                               |
| [Invoke-DownloadsListing](/docs/downloadsdirls.md)           | Lists all files in Windows Users Downloads folders                                                                                              |
| [Invoke-AutostartListing](/docs/autostartls.md)              | Lists all files in Windows Users Startup folder                                                                                                 |
| [Invoke-ShortcutTargetListing](/docs/lnkls.md)               | Lists all lnk files together with their respective target arguments                                                                             |
| [Invoke-TempDirectoriesListing](/docs/temdirls.md)           | Lists all files in Windows Users and System Temp folders                                                                                        |
| [Invoke-ZoneIdentifierListing](/docs/zoneidentifierls.md)    | Lists all Zone Identifier Values from Alternate Data Streams                                                                                    |
| [Invoke-ADSListing](/docs/adsls.md)                          | Lists all Alternate Data Streams                                                                                                                |
| [Invoke-LiveWindowsEventCollection](docs/livewineventcol.md) | Work in Progess / Collects Windows Events from a live system                                                                                    |
| Invoke-ADSListing                                            | Work in Progress / Lists all Alternate Data Streams (ADS) and its contents                                                                      |
| Invoke-AutostartListing                                      | Work in Progress / Lists all Files in Autostart Directory                                                                                       |
| Invoke-DcForensics                                           | Work in Progress / Collects Domain Controller relevant data                                                                                     |
| Invoke-RegistryMalwareSearch                                 | Work in Progress / Searches for persistence in the registry                                                                                     |
| Invoke-InvestigationDocumentation                            | Work in Progress / Provides a menu to setup a document structure to take notes, ioc, and a timeline for each system to be investigated          |