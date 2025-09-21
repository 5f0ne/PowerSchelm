function Invoke-FileEnum {
    param(
        $EnumPath,
        $EnumFilters="",
        $ResultPath
    )
    $p = "$ResultPath\file-enumeration.csv"
    if ($EnumFilters -eq "") {
        # Enumerates all files in the fiven path
        Get-ChildItem -Path $EnumPath -Recurse -Force | Select-Object -Property Extension, Length, CreationTimeUtc, LastAccessTimeUtc, LastWriteTimeUtc, FullName | 
        Export-Csv $p -NoTypeInformation
    }
    else {
        # Enumerates only the files described by the given file extensions
        $filters_ready = @()
        $result = @()
        $filters = $EnumFilters.Split(",").trim()
        foreach ($f in $filters) {
            $filters_ready += "*." + $f
        }
        Get-ChildItem -Path $EnumPath -Recurse -Force | Select-Object -Property Extension, Length, CreationTimeUtc, LastAccessTimeUtc, LastWriteTimeUtc, FullName | ForEach-Object {
            foreach ($v in $filters_ready) {
                if ($_.FullName -Like $v) {
                    $result += $_
                }
            }
        }
        $result | Export-Csv $p -NoTypeInformation
    }   
}