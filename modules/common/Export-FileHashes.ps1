function Export-FileHashes {
    param (
        $HashPath,
        $ResultPath
    )
    # Hash all the files
    $files = Get-ChildItem -Recurse $HashPath

    $hash_array = @()
    foreach ($f in $files) {
        $hash_array += Get-Hashes -Path $f.FullName
    }

    $hash_array | Select-Object FullName, MD5, SHA256 | Export-Csv "$ResultPath\hashes.csv" -NoTypeInformation
}