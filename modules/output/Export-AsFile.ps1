function  Export-AsFile {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        $InputObject,
        [Parameter(Mandatory=$true)]
        $Path
    )

    process {
        $InputObject | Out-File -Append -FilePath $Path
    }
}