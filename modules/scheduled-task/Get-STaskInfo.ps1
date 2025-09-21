function Get-STaskInfo {
    $result = Get-ScheduledTask | Get-ScheduledTaskInfo
    , $result
}