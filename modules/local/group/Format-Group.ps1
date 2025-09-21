
function Format-Group {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [object[]] $InputObject
    )

    process {
        $result = $InputObject | Select-Object PrincipalSource, SID, Name, Description
        ,$result
    }
}
