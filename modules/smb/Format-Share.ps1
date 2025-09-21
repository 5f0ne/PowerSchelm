function Format-Share {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [object[]] $InputObject
    )

    process {
        $result = $InputObject | Select-Object ShareState, ShareType, CurrentUsers, Name, Path, Description, ScopeName
        , $result
    }
}