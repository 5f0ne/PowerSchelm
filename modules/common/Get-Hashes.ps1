function Get-Hashes {
    param($Path)
    $Md5 = Get-FileHash -Algorithm MD5 -LiteralPath $Path | Select-Object Hash
    $Sha256 = Get-FileHash -Algorithm SHA256 -LiteralPath $Path  | Select-Object Hash
    $HashValues = New-Object -TypeName PSObject -Property @{
        "FullName" = $Path
        "MD5" = $Md5.Hash
        "SHA256" = $Sha256.Hash
    }
    return $HashValues
}