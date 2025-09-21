function Format-STaskInfo {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [object[]] $InputObject
    )

    process {
        $result = $InputObject | Select-Object TaskName, TaskPath, LastTaskResult, LastRunTime, NextRunTime
        , $result
    }
}