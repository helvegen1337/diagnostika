# Diagnostika v2.0 - PowerShell 7 Version
# Universal diagnostic system

function Diagnostika {
    param([Parameter(ValueFromRemainingArguments=$true)][string[]]$Category)
    
    # Combine all arguments into one string
    $CategoryString = $Category -join " "
    
    # Main menu
    if (-not $CategoryString) {
        Write-Host "================================================================" -ForegroundColor Cyan
        Write-Host "                Diagnostika v2.0 - Universal System" -ForegroundColor Cyan
        Write-Host "================================================================" -ForegroundColor Cyan
        Write-Host "                         Available Categories" -ForegroundColor White
        Write-Host "1. Network Diagnostics" -ForegroundColor White
        Write-Host "2. System Information" -ForegroundColor White
        Write-Host "3. Storage Analysis" -ForegroundColor White
        Write-Host "4. Security Check" -ForegroundColor White
        Write-Host "5. Performance Monitoring" -ForegroundColor White
        Write-Host ""
        Write-Host "Usage: Diagnostika <category>" -ForegroundColor Yellow
        Write-Host "Examples:" -ForegroundColor Yellow
        Write-Host "  Diagnostika network    - Network diagnostics" -ForegroundColor White
        Write-Host "  Diagnostika system     - System information" -ForegroundColor White
        Write-Host "  Diagnostika storage    - Storage analysis" -ForegroundColor White
        Write-Host "  Diagnostika security   - Security check" -ForegroundColor White
        Write-Host "  Diagnostika performance - Performance monitoring" -ForegroundColor White
        return
    }
    
    # Call appropriate function
    Diagnostika-Windows $CategoryString
}

# Function for Windows
function Diagnostika-Windows {
    param([string]$Category = "")
    
    switch ($Category.ToLower()) {
        "network" {
            Write-Host "================================================================" -ForegroundColor Cyan
            Write-Host "                        NETWORK DIAGNOSTICS" -ForegroundColor Cyan
            Write-Host "================================================================" -ForegroundColor Cyan
            Write-Host "1. Network interfaces" -ForegroundColor White
            Write-Host "2. Network connections" -ForegroundColor White
            Write-Host "3. Routing table" -ForegroundColor White
            Write-Host "4. DNS configuration" -ForegroundColor White
            Write-Host "5. Network statistics" -ForegroundColor White
            Write-Host "6. Ping test" -ForegroundColor White
            Write-Host "7. Traceroute" -ForegroundColor White
            Write-Host "8. Bandwidth test" -ForegroundColor White
            Write-Host "0. Back to main menu" -ForegroundColor Yellow
            Write-Host "q. Exit Diagnostika" -ForegroundColor Yellow
            Write-Host ""
            $choice = Read-Host "Select command (1-8, 0, q)"
            
            switch ($choice) {
                "1" { 
                    Write-Host "Executing: Network interfaces" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-NetAdapter | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "network"
                }
                "2" { 
                    Write-Host "Executing: Network connections" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-NetTCPConnection | Select-Object -First 10 | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "network"
                }
                "3" { 
                    Write-Host "Executing: Routing table" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-NetRoute | Select-Object -First 10 | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "network"
                }
                "4" { 
                    Write-Host "Executing: DNS configuration" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-DnsClientServerAddress | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "network"
                }
                "5" { 
                    Write-Host "Executing: Network statistics" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-NetStatistics | Select-Object -First 10 | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "network"
                }
                "6" { 
                    Write-Host "Executing: Ping test" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Test-Connection -ComputerName "8.8.8.8" -Count 3
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "network"
                }
                "7" { 
                    Write-Host "Executing: Traceroute" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Test-NetConnection -ComputerName "8.8.8.8" -TraceRoute
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "network"
                }
                "8" { 
                    Write-Host "Executing: Bandwidth test" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Bandwidth test not available in PowerShell" -ForegroundColor Yellow
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "network"
                }
                "0" { Diagnostika }
                "q" { Write-Host "Goodbye!" -ForegroundColor Green; return }
                default { 
                    Write-Host "Invalid choice" -ForegroundColor Red
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "network"
                }
            }
        }
        "system" {
            Write-Host "================================================================" -ForegroundColor Cyan
            Write-Host "                     SYSTEM INFORMATION" -ForegroundColor Cyan
            Write-Host "================================================================" -ForegroundColor Cyan
            Write-Host "1. System information" -ForegroundColor White
            Write-Host "2. Processor information" -ForegroundColor White
            Write-Host "3. Memory information" -ForegroundColor White
            Write-Host "4. Disk usage" -ForegroundColor White
            Write-Host "5. System load" -ForegroundColor White
            Write-Host "6. Top processes" -ForegroundColor White
            Write-Host "7. Service status" -ForegroundColor White
            Write-Host "8. System logs" -ForegroundColor White
            Write-Host "9. Windows version" -ForegroundColor White
            Write-Host "0. Back to main menu" -ForegroundColor Yellow
            Write-Host "q. Exit Diagnostika" -ForegroundColor Yellow
            Write-Host ""
            $choice = Read-Host "Select command (1-9, 0, q)"
            
            switch ($choice) {
                "1" { 
                    Write-Host "Executing: System information" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-ComputerInfo | Select-Object WindowsProductName, WindowsVersion, TotalPhysicalMemory | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "system"
                }
                "2" { 
                    Write-Host "Executing: Processor information" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-CimInstance -ClassName Win32_Processor | Select-Object Name, NumberOfCores, MaxClockSpeed | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "system"
                }
                "3" { 
                    Write-Host "Executing: Memory information" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object TotalVisibleMemorySize, FreePhysicalMemory | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "system"
                }
                "4" { 
                    Write-Host "Executing: Disk usage" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-CimInstance -ClassName Win32_LogicalDisk | Select-Object DeviceID, Size, FreeSpace | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "system"
                }
                "5" { 
                    Write-Host "Executing: System load" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-CimInstance -ClassName Win32_Processor | Select-Object LoadPercentage | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "system"
                }
                "6" { 
                    Write-Host "Executing: Top processes" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "system"
                }
                "7" { 
                    Write-Host "Executing: Service status" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-Service | Where-Object {$_.Status -eq "Running"} | Select-Object -First 10 | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "system"
                }
                "8" { 
                    Write-Host "Executing: System logs" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-WinEvent -LogName System -MaxEvents 10 | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "system"
                }
                "9" { 
                    Write-Host "Executing: Windows version" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    [System.Environment]::OSVersion
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "system"
                }
                "0" { Diagnostika }
                "q" { Write-Host "Goodbye!" -ForegroundColor Green; return }
                default { 
                    Write-Host "Invalid choice" -ForegroundColor Red
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "system"
                }
            }
        }
        default {
            Write-Host "Unknown category: $Category" -ForegroundColor Red
            Write-Host "Available categories: network, system" -ForegroundColor Yellow
        }
    }
}

# Create aliases
Set-Alias -Name diag -Value Diagnostika
Set-Alias -Name help -Value Diagnostika
Set-Alias -Name menu -Value Diagnostika 