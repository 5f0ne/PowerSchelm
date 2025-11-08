param(
  $Path,
  $Output = ".\results\mailheaderforensics",
  $FileName = "available-mails.csv",
  $HeaderFileName = "InternetHeaders.txt"
    
)

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

# Output dir
New-Directory -Path $basePath

#---------------------------------------------------------------------------------------------------------
# Setup
#---------------------------------------------------------------------------------------------------------

Get-ChildItem -Path $Path -Recurse -Filter $HeaderFileName -File | ForEach-Object {
  $raw = Get-Content -Raw -Path $_.FullName
  # unfold wrapped header lines and stop at first blank line
  $unfolded = ($raw -replace "`r`n", "`n") -replace "(`n)[`t ]+", ' '
  $header = ($unfolded -split "`n`n", 2)[0]

  $date = [regex]::Match($header, '(?im)^[ \t]*Date:\s*(.*)$').Groups[1].Value
  $from = [regex]::Match($header, '(?im)^[ \t]*From:\s*(.*)$').Groups[1].Value
  $to = [regex]::Match($header, '(?im)^[ \t]*To:\s*(.*)$').Groups[1].Value
  $subj = [regex]::Match($header, '(?im)^[ \t]*Subject:\s*(.*)$').Groups[1].Value
  $rp = [regex]::Match($header, '(?im)^[ \t]*Return-Path:\s*(.*)$').Groups[1].Value
  $rt = [regex]::Match($header, '(?im)^[ \t]*Reply-To:\s*(.*)$').Groups[1].Value

  [pscustomobject]@{
    Path       = $_.FullName
    Date       = $date
    From       = $from
    To         = $to
    Subject    = $subj
    ReturnPath = $rp
    ReplyTo    = $rt
  }
} | Export-Csv -NoTypeInformation -Encoding UTF8 -Path "$basePath\$FileName"