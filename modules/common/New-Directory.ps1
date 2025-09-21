function New-Directory {
    param ($Path)
    
    if (-not (Test-Path -LiteralPath $Path)) {
        try {
            New-Item -Path $Path -ItemType Directory -ErrorAction Stop | Out-Null #-Force
        }
        catch {
            Write-Error -Message "Unable to create directory " + $Path + ". Error was: $_" -ErrorAction Stop
        }
        "Successfully created directory " + $Path + "."
    }
    else {
        "Directory already existed"
    }
}