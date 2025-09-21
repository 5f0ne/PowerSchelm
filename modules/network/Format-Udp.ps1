function Format-Udp {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [object[]] $InputObject
    )

    process {
        $result = $InputObject | Select-Object CreationTime, EnabledDefault, RequestedState, TransitioningToState, LocalAddress, LocalPort, OwningProcess
        ,$result
    }
}
