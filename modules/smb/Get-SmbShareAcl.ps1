function Get-SmbShareAcl {
    param (
        $Path
    )
    
    $shares = Get-SmbShare 

    foreach ($share in $shares) {
 
        $result = Get-SmbShareAccess -Name $share.Name

        if ($null -ne $result) {
            # to have consistent file names, tasknames with spaces are replaced with underscores.
            $taskName = $share.Name.Replace(" ", "_")
            $p = "$Path\$taskName.csv"
            $result | Select-Object AccessCOntrolType, AccessRight, AccountName, Name, ScopeName | Export-Csv $p -NoTypeInformation
        }
    }
}