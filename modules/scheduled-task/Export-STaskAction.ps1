function Export-STaskAction {
    param (
        $XmlPath,
        $ResultPath
    )

    # Get ScheduledTasks Actions from XML Exports
    $files = Get-ChildItem -Path $XmlPath -Include *.xml -Recurse

    $resultExec = @()
    $resultCH = @()
    $resultSendMail = @()
    $resultShowMsg = @()

    ForEach ($file in $files) {
        $xml = [xml](Get-Content $file)
        if ($xml.Task.Actions.Exec) {
            $xml.Task.Actions.Exec | ForEach-Object {
                $obj = New-Object -TypeName PSObject -Property @{     
                    "URI"         = $xml.Task.RegistrationInfo.URI
                    "Date"        = $xml.Task.RegistrationInfo.Date
                    "Author"      = $xml.Task.RegistrationInfo.Author
                    "Command"     = $_.Command
                    "Arguments"   = $_.Arguments
                    "Description" = $xml.Task.RegistrationInfo.Description
                }
                $resultExec += $obj 
            } 
        } 
        if ($xml.Task.Actions.ComHandler) {
            $xml.Task.Actions.ComHandler | ForEach-Object {
                $obj = New-Object -TypeName PSObject -Property @{     
                    "URI"         = $xml.Task.RegistrationInfo.URI
                    "Date"        = $xml.Task.RegistrationInfo.Date
                    "Author"      = $xml.Task.RegistrationInfo.Author
                    "ClassId"     = $_.ClassId
                    "Data"        = $_.Data
                    "Description" = $xml.Task.RegistrationInfo.Description
                }
                $resultCH += $obj 
            } 
        } 
        if ($xml.Task.Actions.SendEmail) {
            $xml.Task.Actions.SendEmail | ForEach-Object {
                $obj = New-Object -TypeName PSObject -Property @{     
                    "URI"          = $xml.Task.RegistrationInfo.URI
                    "Date"         = $xml.Task.RegistrationInfo.Date
                    "Author"       = $xml.Task.RegistrationInfo.Author
                    "Server"       = $_.Server
                    "Subject"      = $_.Subject
                    "To"           = $_.To
                    "Cc"           = $_.Cc
                    "Bcc"          = $_.Bcc
                    "ReplyTo"      = $_.ReplyTo
                    "From"         = $_.From
                    "HeaderFields" = $_.HeaderFields
                    "Body"         = $_.Body
                    "Attachments"  = $_.Attachments
                    "Description"  = $xml.Task.RegistrationInfo.Description
                }
                $resultSendMail += $obj 
            } 
        } 
        if ($xml.Task.Actions.ShowMessage) {
            $xml.Task.Actions.ShowMessage | ForEach-Object {
                $obj = New-Object -TypeName PSObject -Property @{     
                    "URI"         = $xml.Task.RegistrationInfo.URI
                    "Date"        = $xml.Task.RegistrationInfo.Date
                    "Author"      = $xml.Task.RegistrationInfo.Author
                    "Title"       = $_.Title
                    "Body"        = $_.Body
                    "Description" = $xml.Task.RegistrationInfo.Description
                }
                $resultShowMsg += $obj 
            } 
        }   
    }

    if ($resultExec.Length -gt 0) {
        $resultExec | Select-Object Date, URI, Command, Arguments, Author, Description | Export-Csv "$ResultPath\scheduled-tasks-action-exec.csv" -NoTypeInformation
    }

    if ($resultCH.Length -gt 0) {
        $resultCH | Select-Object Date, URI, ClassId, Data, Author, Description | Export-Csv "$ResultPath\scheduled-tasks-action-comhandler.csv" -NoTypeInformation
    }

    if ($resultSendMail.Length -gt 0) {
        $resultSendMail | Select-Object Date, URI, Server, Subject, To, Cc, Bcc, ReplyTo, From, HeaderFields, Body, Author, Description | Export-Csv "$ResultPath\scheduled-tasks-action-sendmail.csv" -NoTypeInformation
    }

    if ($resultShowMsg.Length -gt 0) {
        $resultShowMsg | Select-Object Date, URI, Title, Body, Author, Description | Export-Csv "$ResultPath\scheduled-tasks-action-showmsg.csv" -NoTypeInformation
    }    
}