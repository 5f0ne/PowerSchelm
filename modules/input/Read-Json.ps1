function Read-Json {
    param($Path)
    $json = Get-Content -Raw -Path $path | ConvertFrom-Json
    return $json
}