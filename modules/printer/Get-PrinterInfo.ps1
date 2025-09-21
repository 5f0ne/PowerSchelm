function Get-PrinterInfo {
    param (
        $Path
    )
    Get-Printer | Select-Object Name, ComputerName, Type, DriverName, PortName, Shared, Published, DeviceType | Export-Csv "$Path\printers.csv" -NoTypeInformation
}