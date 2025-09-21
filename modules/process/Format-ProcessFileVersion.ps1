
function Format-ProcessFileVersion {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [object[]] $InputObject
    )

    process {
        $result = $InputObject | Select-Object FileVersion, CompanyName, Language, FileName, InternalName, OriginalFilename, ProductName, FileDescription, Comments
        ,$result
    }
}
