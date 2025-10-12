function Get-FileBom {
    param([Parameter(Mandatory)][string]$Path)

    $b = Get-Content -Encoding Byte -TotalCount 4 -Path $Path
    $sig = -join ($b | ForEach-Object { '{0:X2}' -f $_ })

    switch -Regex ($sig) {
        '^EFBBBF' { $true ; break } # 'UTF-8 BOM'
        '^FFFE' { $true ; break } # 'UTF-16 LE BOM'
        '^FEFF' { $true ; break } # 'UTF-16 BE BOM' 
        '^FFFE0000' { $true ; break } # 'UTF-32 LE BOM'
        '^0000FEFF' { $true ; break } # 'UTF-32 BE BOM'
        default { $false }
    }
}