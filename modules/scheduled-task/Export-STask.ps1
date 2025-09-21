function Export-STask {
    param (
        $Path
    )

    $tasks = Get-ScheduledTask 

    foreach ($task in $tasks) {
        $result = Export-ScheduledTask -TaskName $task.TaskName -TaskPath $task.TaskPath

        if ($null -ne $result) {
            # to have consistent file names, tasknames with spaces are replaced with underscores.
            $taskName = $task.TaskName.Replace(" ", "_")
            $result | Out-File -FilePath "$Path\$taskName.xml"
        }
    }
}