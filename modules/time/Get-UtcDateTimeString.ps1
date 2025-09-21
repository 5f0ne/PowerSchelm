function Get-UtcString {
    param($DateObject)
    return $DateObject.ToString("dd-MM-yyyy_HH-mm-ssZ")
}