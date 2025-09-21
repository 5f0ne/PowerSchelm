
function Format-User {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [object[]] $InputObject
    )

    process {
        $result = $InputObject | Select-Object Enabled, SID, PrincipalSource, FullName, UserMayChangePassword, PasswordRequired, Name, LastLogon, PasswordChangeableDate, PasswordExpires, PasswordLastSet, Description
        ,$result
    }
}
