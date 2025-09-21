
function Format-Tcp {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [object[]] $InputObject
    )

    process {
        $result = $InputObject | Select-Object State, CreationTime, LocalAddress, LocalPort, RemoteAddress, RemotePort, OwningProcess
        ,$result
    }
}
