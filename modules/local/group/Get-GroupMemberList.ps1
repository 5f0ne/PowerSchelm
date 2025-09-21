function Get-GroupMemberList {
    # Get Members for each group
    $groupMembersList = @()

    # Get all local groups
    Get-LocalGroup | Select-Object Name | ForEach-Object { 
        # Get the name of each local group to request group members
        $members = Get-LocalGroupMember $_.Name 

        # $memberString is the string in which all member names get appended for the specific group
        $memberStr = ""
        $members | ForEach-Object { $memberStr += $_.Name + " | " }

        # The final object with the group name / member mapping is created
        $obj = New-Object -TypeName PSObject -Property @{     
            "GroupName" = $_.Name
            "Members"   = $memberStr
        }
        $groupMembersList += $obj 
    }
    ,$groupMembersList
}