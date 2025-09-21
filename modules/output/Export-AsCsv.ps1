function  Export-AsCsv {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [object[]] $InputObject,
        $Path
    )

    process {
        $InputObject | Export-Csv $Path -NoTypeInformation
    }
}