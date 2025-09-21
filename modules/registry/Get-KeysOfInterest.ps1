function Get-RegistryValues {
    param($Path, $KeyName = "")
    $result = "No value found!"
    if ($KeyName -eq "") {
        $result = Get-ItemProperty $Path
    }
    else {
        $result = Get-ItemProperty $Path -Name $KeyName
    }
    return $result
}

function Get-KeysOfInterest {
    param (
        $Path
    )
    
    $p = "$Path\reg-keys-of-interest.txt"

    $regKeys = @(@{Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
            KeyName     = "" 
        },
        @{Path      = "HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
            KeyName = "" 
        },
        @{Path      = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Windows\Run"
            KeyName = "" 
        },
        @{Path      = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run"
            KeyName = "" 
        },
        @{Path      = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders"
            KeyName = "" 
        },
        @{Path      = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders"
            KeyName = "" 
        },
        @{Path      = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon"
            KeyName = "" 
        },
        @{Path      = "HKCU:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce"
            KeyName = "" 
        }
        @{Path      = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\MountPoints2"
            KeyName = "" 
        }
        # -------------------------------------------------------------    
        @{Path      = "HKCU:\Environment"
            KeyName = "UserInitMprLogonScript" 
        },
        @{Path      = "HKCU:\Control Panel\Desktop"
            KeyName = "SCRNSAVE.EXE" 
        },
        # -------------------------------------------------------------
        @{Path      = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run"
            KeyName = "" 
        },
        @{Path      = "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
            KeyName = "" 
        },
        @{Path      = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run"
            KeyName = "" 
        },
        @{Path      = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run\Services"
            KeyName = "" 
        },
        @{Path      = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run\Services\Once"
            KeyName = "" 
        },
        @{Path      = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders"
            KeyName = "" 
        },
        @{Path      = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders"
            KeyName = "" 
        },
        @{Path      = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon"
            KeyName = "" 
        },
        @{Path      = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\IniFileMapping\system.ini\boot"
            KeyName = "" 
        },
        @{Path      = "HKLM:\System\CurrentControlSet\Control\SecurityProviders\WDigest"
            KeyName = "" 
        },
        @{Path      = "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run"
            KeyName = "" 
        }
        # -------------------------------------------------------------
        @{Path      = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Windows"
            KeyName = "AppInit_DLLs" 
        },
        @{Path      = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon"
            KeyName = "Userinit" 
        },
        @{Path      = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager"
            KeyName = "BootExecute" 
        },
        @{Path      = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager"
            KeyName = "KnownDLLs" 
        })

    $regKeys | ForEach-Object {
        $result = Get-RegistryValues -Path $_.Path -KeyName $_.KeyName
        $path = $_.Path
        $key = $_.KeyName
        $heading = "`n--> $path $key `n---`n"
        $heading | Out-File -Append -FilePath $p
        $result | Out-File -Append -FilePath $p
        $line = "----------------------------------------------------------------------------------------------------------"
        $line | Out-File -Append -FilePath $p
    }
}