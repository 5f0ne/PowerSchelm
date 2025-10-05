## Invoke-LiveBoxForensics

Collects information from running systems

### Usage

`.\Invoke-LiveBoxForensics.ps1 -ErrorActionPreference [STRING] -Output [STRING] -AdsEnumPath [STRING] -FileEnumPath [STRING] -LnkEnumPath [STRING] -FileEnumFilters [STRING] -EnumerateADS [BOOL] -EnumerateFiles [BOOL] -EnumerateShortcuts [BOOL] -EnumerateFileAssociation [BOOL] -Archive [BOOL]`

| Option                    | Type    | Default                    | Description                                                                                                                                                                                                    |
| ------------------------- | ------- | -------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| -ErrorActionPreference    | String  | SilentlyContinue           | Powershell variable to defined what happens, when an error occur.                                                                                                                                              |
| -Output                   | String  | .\results\liveboxforensics | Path to write Live Box Forensics output                                                                                                                                                                        |
| -AdsEnumPath              | String  | $env:USERPROFILE           | Path for alternate data stream enumeration                                                                                                                                                                     |
| -FileEnumPath             | String  | $env:USERPROFILE           | Path for directory / file enumeration                                                                                                                                                                          |
| -LnkEnumPath              | String  | $env:USERPROFILE           | Path for shortcut enumeration                                                                                                                                                                                  |
| -FileEnumFilters          | String  | ""                         | Enumerates only files with the given file extension in $FileEnumPath. Example: -FileEnumFilters "pdf,docx,png". If no filters are given (default value), all files in $FileEnumPath are going to be enumerated |
| -EnumerateADS             | Boolean | $false                     | If true, searches for alternate data streams in all files located in $AdsEnumPath                                                                                                                              |
| -EnumerateFiles           | Boolean | $false                     | If true, enumerates all files to provide a list of file paths located in $FileEnumPath                                                                                                                         |
| -EnumerateShortcuts       | Boolean | $false                     | If true, enumerates all shortcuts to provide a list of the shortcut`s target property located in $LnkEnumPath                                                                                                  |
| -EnumerateFileAssociation | Boolean | $false                     | If true, enumerate file association in the registry and their associated programm to open it                                                                                                                   |
| -Archive                  | Boolean | $false                     | If true, an archive of the files is created and hashed                                                                                                                                                         |

### Result

Creates the following folder structure with information saved to `txt` and `csv` files in the given folders:

```txt
\---liveboxforensics
    \---System-Name.01-01-1970_12-00-00Z
        +---00-system
        +---01-process
        +---02-network
        +---03-firewall
        +---04-smb
        +---05-service
        +---06-local-user
        +---07-local-group
        +---08-scheduled-tasks
        |   \---export
        +---09-powershell
        |   +---history
        |   \---transcript
        +---10-wmi
        +---11-printer
        +---12-prefetch
        +---13-evtx
        +---14-installed-programs
        +---15-installed-hotfixes
        +---16-autostart-folder
        +---17-registry
        +---18-shortcut-enumeration
        +---19-alternate-data-streams
        +---20-file-enumeration
        \---99-error
```