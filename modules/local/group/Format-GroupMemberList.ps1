
function Format-GroupMemberList {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [object[]] $InputObject
    )

    process {
        $result = $InputObject | Select-Object GroupName, Members
        ,$result
    }
}
