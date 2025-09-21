function Format-DnsCache {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [object[]] $InputObject
    )

    process {
        $result = $InputObject | Select-Object Status, Type, Entry, Name, DataLength, Data, TimeToLive
        ,$result
    }
}
