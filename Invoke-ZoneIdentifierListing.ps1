# This script shall list all files with a ZoneIdentifier ADS and extract the information
# Files listed are downloaded from the internet

# Admin Rights are needed

param(
    [Parameter(Mandatory = $true)]
    [string]$Path,

    [string]$Output = ".\results\zone-identifier-listing"
)

#---------------------------------------------------------------------------------------------------------
# Function
#---------------------------------------------------------------------------------------------------------

# Helper: parse the text inside Zone.Identifier into a hashtable (key=value)
function Invoke-ZoneIdentifierParsing {
    param([string]$Content)

    $map = @{}
    foreach ($line in ($Content -split "(\r?\n)")) {
        $t = $line.Trim()
        if (-not $t) { continue }
        if ($t -match '^\s*\[ZoneTransfer\]\s*$') { continue }

        # Most fields are "Key=Value"
        if ($t -match '^\s*([^=]+?)\s*=\s*(.*)\s*$') {
            $k = $matches[1].Trim()
            $v = $matches[2].Trim()
            $map[$k] = $v
        }
    }
    return $map
}

#---------------------------------------------------------------------------------------------------------
# Import
#---------------------------------------------------------------------------------------------------------

. $PSScriptRoot\modules\common\New-Directory.ps1

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

# Collect results
$results = New-Object System.Collections.Generic.List[object]

# Enumerate files (skip directories)
Get-ChildItem -LiteralPath $Path -Recurse -File -Force -ErrorAction SilentlyContinue |
ForEach-Object {
    $file = $_.FullName
    $streamPath = "$file`:Zone.Identifier"

    try {
        # Fast check: does Zone.Identifier exist?
        # (Using Get-Item -Stream is reliable on NTFS, but can throw on some paths)
        $hasStream = $false
        try {
            $streams = Get-Item -LiteralPath $file -Stream * -ErrorAction Stop
            if ($streams.Stream -contains 'Zone.Identifier') { $hasStream = $true }
        }
        catch {
            # Fall back: try reading directly
            $hasStream = $false
        }

        if (-not $hasStream) { return }

        # Read ADS content
        $content = Get-Content -LiteralPath $streamPath -Raw -ErrorAction Stop
        if (-not $content) { return }

        $kv = Invoke-ZoneIdentifierParsing -Content $content

        # Build output row (include common fields, plus raw content for completeness)
        $results.Add([pscustomobject]@{
                Extension         = $_.Extension
                CreationTimeUtc   = $_.CreationTimeUtc
                LastAccessTimeUtc = $_.LastAccessTimeUtc
                LastWriteUtc      = $_.LastWriteTimeUtc
                ZoneId            = $kv['ZoneId']
                ReferrerUrl       = $kv['ReferrerUrl']
                HostUrl           = $kv['HostUrl']            
                LengthBytes       = $_.Length
                FilePath          = $file
            })
    }
    catch {
        continue
    }
}

# Write CSV
$p = Join-Path $basePath "zone-identifier-listing.csv"
$results | Sort-Object FilePath | Export-Csv -LiteralPath $p -NoTypeInformation -Encoding UTF8
