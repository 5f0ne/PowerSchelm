
function Format-CimProcess {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [object[]] $InputObject
    )

    process {
        $result = $InputObject | Select-Object CreationDate, CSName, SessionId, ProcessId, ParentProcessId, ProcessName, CommandLine, ExecutablePath | Sort-Object ProcessId
        ,$result
    }
}
