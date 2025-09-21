function Format-Map {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [object[]] $InputObject
    )

    process {
        $result = $InputObject | Select-Object LocalPath, Status, RemotePath
        , $result
    }
}