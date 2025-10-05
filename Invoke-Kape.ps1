param(
    $Path,
    $OutputPath=".\results\kape",
    $KapePath="kape.exe",
    $KapeTargets="!BasicCollection,!SANS_Triage,KapeTriage,ServerTriage,CombinedLogs,IRCClients,RecycleBin,RemoteAdmin,SOFELK,SQLiteDatabases,TorrentClients,RecentFileCache,StartupFolders"
)

$param="--tsource $Path --tdest $OutputPath --target $KapeTargets"

Start-Process -FilePath $KapePath -ArgumentList $param  -Wait -NoNewWindow -RedirectStandardOutput "$OutputPath\kape-log.txt" -RedirectStandardError "$OutputPath\kape-error.txt"