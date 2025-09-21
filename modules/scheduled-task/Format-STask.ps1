function Format-STask {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [object[]] $InputObject
    )

    process {
        $result = $InputObject | Select-Object State, Author, Date, TaskName, TaskPath, URI, Description
        , $result
    }
}