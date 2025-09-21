
function Format-CimService {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [object[]] $InputObject
    )

    process {
        $result = $InputObject | Select-Object Started, State, ProcessId, Name, StartName, Status, PathName, StartMode, ExitCode, Caption, Description | Sort-Object ProcessId
        , $result
    }
}
