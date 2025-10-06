# PowerSchelm

Powershell Data Aquisition and Analysis Framework (PD2AF) - Different Powershell Tools for Data Aquisition and Analysis

## Overview

| Name                         | Description                                                                                       |
| ---------------------------- | ------------------------------------------------------------------------------------------------- |
| Invoke-Kape                  | Collects files with KAPE                                                                          |
| Invoke-LiveBoxForensics      | Use it if you have a running system and you are interested in evidence collection                 |
| Invoke-EZToolsForensics      | Use it in combination with an KAPE image to parse artifacts with EZTools                          |
| Invoke-RamForensics          | Uses bstrings and Volatility to collect information from ram images                               |
| Invoke-Autoruns              | Uses autorunsc to collect ASEP from an offline image                                              |
| Invoke-HayabusaForensics     | Work in Progress / Use it in combination with an KAPE image to parse the evtx files with hayabusa |
| Invoke-DcForensics           | Work in Progress / Collects Domain Controller relevant data                                       |
| Invoke-ExchangeForensics     | Work in Progress / Collects Exchange relevant data                                                |
| Invoke-RegistryMalwareSearch | Work in Progress / Searches for persistence in the registry                                       |


## Manuals

- [Invoke-LiveBoxForensics](/docs/liveboxforensics.md)
- [Invoke-EZToolsForensics](/docs/eztoolsforensics.md)
- [Invoke-RamForensics](/docs/ramforensics.md)
- [Invoke-Kape](/docs/kape.md)
- [Invoke-Autoruns](/docs/autorunsc.md)