param(
    $Path,
    $OutputPath=".\results\kape",
    $KapePath="kape.exe",
    $VhdxIdentifier="kape-collection",
    $KapeTargets="!BasicCollection,!SANS_Triage,KapeTriage,ServerTriage,CombinedLogs,IRCClients,RecycleBin,RemoteAdmin,SOFELK,SQLiteDatabases,TorrentClients,RecentFileCache,StartupFolders"
)

$param="--tsource $Path --tdest $OutputPath --target $KapeTargets --vhdx $VhdxIdentifier --vss"

Start-Process -FilePath $KapePath -ArgumentList $param  -Wait -NoNewWindow -RedirectStandardOutput "$OutputPath\kape-log.txt" -RedirectStandardError "$OutputPath\kape-error.txt"