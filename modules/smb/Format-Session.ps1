function Format-Share {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [object[]] $InputObject
    )

    process {
        $result = $InputObject | Select-Object *
        , $result
    }
}