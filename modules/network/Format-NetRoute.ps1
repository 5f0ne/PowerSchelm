function Format-NetRoute {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [object[]] $InputObject
    )

    process {
        $result = $InputObject | Select-Object AddressFamily, State, TypeOfRoute, InterfaceAlias, ifIndex, DestinationPrefix, NextHop, RouteMetric, ifMetric
        ,$result
    }
}
