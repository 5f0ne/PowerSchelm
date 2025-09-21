function Format-FwRule {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [object[]] $InputObject
    )

    process {
        $result = $InputObject | Select-Object Enabled, Direction, Action, Name, Id, DisplayName, Group, Profile, RuleGroup, StatusCode, Description 
        , $result
    }
}