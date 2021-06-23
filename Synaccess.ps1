#Made for PS7
#Connect to synaccess and reboot/shutdown ports
Clear-Host
Write-Warning "Toggle does not differentiate between 'On' or 'Off'. If port is 'Off' using the reboot function will turn the port 'On' and then back 'Off'."
do {
    Write-Host ""
    $IP = Read-Host -Prompt "Enter IP of SynAccess to connect to"
    $AliveTest = Test-Connection -Ping $IP -IPv4 -Count 1
    if (!($AliveTest.Status -eq "Success")) {
        Write-Host ""
        Write-Warning "Invalid host or does not appear to be alive"
    }
}
until ($AliveTest.Status -eq "Success")

do {
    Write-Host ""
    $ConnectError = $null
    $Username = Read-Host -Prompt Username
    $Password = Read-Host -Prompt Password -AsSecureString
    [PSCredential]$Credentials = New-Object System.Management.Automation.PSCredential ($Username, $Password)
    Invoke-WebRequest -Uri ("http://" + "$IP") -Credential $Credentials -AllowUnencryptedAuthentication -SessionVariable Session -ErrorAction SilentlyContinue -ErrorVariable ConnectError | Out-Null
    if ($ConnectError -ne 0) {
        Write-Host "Bad request or creds"
    }
}
until ($ConnectError.message.length -eq 0)

function Tasks {
    Write-Host ""
    Write-host "
Operations:

1. Reboot
2. Toggle On/Off
3. Exit script
"
$global:ActionSelection = Read-Host -Prompt "Which operation?" -ErrorAction SilentlyContinue
if (!($global:ActionSelection -in 1..3)) {
    Write-Host ""
    Write-Warning "Please pick a valid option"
    Tasks
    }
}

function PortSelect {
    Write-Host ""
    Write-Host "
Ports:
    
1. Primary
2. Secondary
3. Starbox
4. Sonicwall
5. Switch
6. Go back
7. Exit script
"
$global:PortSelection = Read-Host -Prompt "Which Port?" -ErrorAction SilentlyContinue
if (!($global:PortSelection -in 1..7)) {
    Write-Host ""
    Write-Warning "Please pick a valid option"
    PortSelect
    }
}

function Operations {
    Clear-Host
    Tasks
    switch ($global:ActionSelection) {
        1 {
            Clear-Host
            PortSelect
            switch ($global:PortSelection) {
                1 {
                    Write-Host ""
                    Write-Warning "Rebooting Primary"
                    Invoke-WebRequest ("http://" + $IP + "/cmd.cgi?rb=0") -WebSession $Session | Out-Null
                }
                2 {
                    Write-Host ""
                    Write-Warning "Rebooting Secondary"
                    Invoke-WebRequest ("http://" + $IP + "/cmd.cgi?rb=1") -WebSession $Session | Out-Null
                }
                3 {
                    Write-Host ""
                    Write-Warning "Rebooting Starbox"
                    Invoke-WebRequest ("http://" + $IP + "/cmd.cgi?rb=2") -WebSession $Session | Out-Null
                }
                4 {
                    Write-Host ""
                    Write-Warning "Rebooting Sonicwall"
                    Invoke-WebRequest ("http://" + $IP + "/cmd.cgi?rb=3") -WebSession $Session | Out-Null
                }
                5 {
                    Write-Host ""
                    Write-Warning "Rebooting Switch"
                    Invoke-WebRequest ("http://" + $IP + "/cmd.cgi?rb=4") -WebSession $Session | Out-Null
                }
                6 {
                    Operations
                }
                7 {
                    Exit
                }
            }
        }
        2 {
            Clear-Host
            PortSelect
            switch ($global:PortSelection) {
                1 {
                    Write-Host ""
                    Write-Warning "Toggling Primary On/Off"
                    Invoke-WebRequest ("http://" + $IP + "/cmd.cgi?rly=0") -WebSession $Session | Out-Null
                }
                2 {
                    Write-Host ""
                    Write-Warning "Toggling Secondary On/Off"
                    Invoke-WebRequest ("http://" + $IP + "/cmd.cgi?rly=1") -WebSession $Session | Out-Null
                }
                3 {
                    Write-Host ""
                    Write-Warning "Toggling Starbox On/Off"
                    Invoke-WebRequest ("http://" + $IP + "/cmd.cgi?rly=2") -WebSession $Session | Out-Null
                }
                4 {
                    Write-Host ""
                    Write-Warning "Toggling Sonicwall On/Off"
                    Invoke-WebRequest ("http://" + $IP + "/cmd.cgi?rly=3") -WebSession $Session | Out-Null
                }
                5 {
                    Write-Host ""
                    Write-Warning "Toggling Switch On/Off"
                    Invoke-WebRequest ("http://" + $IP + "/cmd.cgi?rly=4") -WebSession $Session | Out-Null
                }
                6 {
                    Operations
                }
                7 {
                    Exit
                }
            }
        }
        3 {
            Exit
        }
    }
}

Operations

do {
    Write-Host "
Options:

1. Yes
2. No
"
    $AgainPrompt = Read-Host -Prompt "Run again?"
    if (!($AgainPrompt -in 1..2)) {
        Write-Host ""
        Write-Warning "Please pick a valid option"
    }
    switch ($AgainPrompt) {
        1 {
            Operations        
        }
        2 {
            Exit
        }
    }
}

until ($AgainPrompt -eq 2)