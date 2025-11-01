param(
    $Path,
    $Output = ".\results\mtlforensics",
    $FileName = "message-tracking-log-all.csv",
    $Filter = "*.LOG"
)

#---------------------------------------------------------------------------------------------------------
# Import
#---------------------------------------------------------------------------------------------------------

. $PSScriptRoot\modules\common\New-Directory.ps1

#---------------------------------------------------------------------------------------------------------
# Functions
#---------------------------------------------------------------------------------------------------------

function Read-Fields {
    param (
        $Path,
        $Output
    )

    $map = @{
        "date-time"                 = "DateTime"
        "client-ip"                 = "ClientIp"
        "client-hostname"           = "ClientHostname"
        "server-ip"                 = "ServerIp"
        "server-hostname"           = "ServerHostname"
        "source-context"            = "SourceContext"
        "connector-id"              = "ConnectorId"
        "source"                    = "Source"
        "event-id"                  = "EventId"
        "internal-message-id"       = "InternalMessageId"
        "message-id"                = "MessageId"
        "network-message-id"        = "NetworkMessageId"
        "recipient-address"         = "RecipientAddress"
        "recipient-status"          = "RecipientStatus"
        "total-bytes"               = "TotalBytes"
        "recipient-count"           = "RecipientCount"
        "related-recipient-address" = "RelatedRecipientAddress"
        "reference"                 = "Reference"
        "message-subject"           = "MessageSubject"
        "sender-address"            = "SenderAddress"
        "return-path"               = "ReturnPath"
        "message-info"              = "MessageInfo"
        "directionality"            = "Directionality"
        "tenant-id"                 = "TenantId"
        "original-client-ip"        = "OriginalClientIp"
        "original-server-ip"        = "OriginalServerIp"
        "custom-data"               = "CustomData"
        "transport-traffic-type"    = "TransportTrafficType"
        "log-id"                    = "LogId"
        "schema-version"            = "SchemaVersion"
    }

    $fields = (Get-Content -Path $Path -TotalCount 5 | Select-Object -Last 1).replace("#Fields: ", "")

    $mappedStr = (($fields -split ',') | ForEach-Object { $map[$_] }) -join ','

    $mappedStr | Set-Content -Path $Output
}

#---------------------------------------------------------------------------------------------------------
# Setup
#---------------------------------------------------------------------------------------------------------

$startDateTime = (Get-Date).ToUniversalTime()
$startDateTimeFormatStr = $startDateTime.ToString("dd-MM-yyyy_HH-mm-ssZ")
$basePath = "$Output\$startDateTimeFormatStr"

New-Directory -Path $basePath

#---------------------------------------------------------------------------------------------------------
# Logic
#---------------------------------------------------------------------------------------------------------

$resultFile = "$basePath\$FileName"
$files = @(Get-ChildItem -Path $Path -Filter $Filter -File -Recurse | Select-Object -ExpandProperty FullName)

Write-Host $files[0]

# Due to comments in each log file we first need to extract the field values 
Read-Fields -Path $files[0] -Output $resultFile

# After extraction of field values, we are going to copy each line with csv values to our output file
foreach ($file in $files) {
    # Input and output file paths
    $inputFile = (Resolve-Path $file).Path
    $outputFile = (Resolve-Path $resultFile).Path

    # Open reader and writer
    $reader = [System.IO.StreamReader]::new($inputFile)
    $writer = [System.IO.StreamWriter]::new($outputFile, $true)  # $false = overwrite, $true = append

    # Process line by line
    while ($null -ne ($line = $reader.ReadLine())) {
        if (-not $line.Trim().StartsWith("#")) {
            $writer.WriteLine($line)
        }
    }

    # Clean up
    $reader.Close()
    $writer.Close()
}