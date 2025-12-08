param(
    $Path,
    $OutputPath = ".\results\kape",
    $Vhdx = $False,
    $VhdxIdentifier = "kape-collection",
    $KapePath = "kape.exe",
    $KapeTargets = "!BasicCollection,!SANS_Triage,KapeTriage,ServerTriage,CombinedLogs,IRCClients,RecycleBin,RemoteAdmin,SOFELK,SQLiteDatabases,TorrentClients,RecentFileCache,StartupFolders,CloudStorage_All"
)

if ($Vhdx) {
    $param = "--tsource $Path --tdest $OutputPath --target $KapeTargets --vhdx $VhdxIdentifier --vss"
}
else {
    $param = "--tsource $Path --tdest $OutputPath --target $KapeTargets --vss"

}

Start-Process -FilePath $KapePath -ArgumentList $param  -Wait -NoNewWindow -RedirectStandardOutput "$OutputPath\kape-log.txt" -RedirectStandardError "$OutputPath\kape-error.txt"