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
                    Write-Host "🔧 Executing: Network interfaces" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-NetAdapter | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "✅ Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "network"
                }
                "2" { 
                    Write-Host "🔧 Executing: Network connections" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-NetTCPConnection | Select-Object -First 10 | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "✅ Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "network"
                }
                "3" { 
                    Write-Host "🔧 Executing: Routing table" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-NetRoute | Select-Object -First 10 | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "✅ Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "network"
                }
                "4" { 
                    Write-Host "🔧 Executing: DNS configuration" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-DnsClientServerAddress | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "✅ Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "network"
                }
                "5" { 
                    Write-Host "🔧 Executing: Network statistics" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-NetStatistics | Select-Object -First 10 | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "✅ Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "network"
                }
                "6" { 
                    Write-Host "🔧 Executing: Ping test" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Test-Connection -ComputerName "8.8.8.8" -Count 3
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "✅ Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "network"
                }
                "7" { 
                    Write-Host "🔧 Executing: Traceroute" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Test-NetConnection -ComputerName "8.8.8.8" -TraceRoute
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "✅ Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "network"
                }
                "8" { 
                    Write-Host "🔧 Executing: Bandwidth test" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Bandwidth test not available in PowerShell" -ForegroundColor Yellow
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "✅ Command completed" -ForegroundColor Green
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
                    Write-Host "🔧 Executing: System information" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-ComputerInfo | Select-Object WindowsProductName, WindowsVersion, TotalPhysicalMemory | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "✅ Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "system"
                }
                "2" { 
                    Write-Host "🔧 Executing: Processor information" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-CimInstance -ClassName Win32_Processor | Select-Object Name, NumberOfCores, MaxClockSpeed | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "✅ Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "system"
                }
                "3" { 
                    Write-Host "🔧 Executing: Memory information" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object TotalVisibleMemorySize, FreePhysicalMemory | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "✅ Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "system"
                }
                "4" { 
                    Write-Host "🔧 Executing: Disk usage" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-CimInstance -ClassName Win32_LogicalDisk | Select-Object DeviceID, Size, FreeSpace | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "✅ Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "system"
                }
                "5" { 
                    Write-Host "🔧 Executing: System load" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-CimInstance -ClassName Win32_Processor | Select-Object LoadPercentage | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "✅ Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "system"
                }
                "6" { 
                    Write-Host "🔧 Executing: Top processes" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "✅ Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "system"
                }
                "7" { 
                    Write-Host "🔧 Executing: Service status" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-Service | Where-Object {$_.Status -eq "Running"} | Select-Object -First 10 | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "✅ Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "system"
                }
                "8" { 
                    Write-Host "🔧 Executing: System logs" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-WinEvent -LogName System -MaxEvents 10 | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "✅ Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "system"
                }
                "9" { 
                    Write-Host "🔧 Executing: Windows version" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    [System.Environment]::OSVersion
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "✅ Command completed" -ForegroundColor Green
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
        "storage" {
            Write-Host "================================================================" -ForegroundColor Cyan
            Write-Host "                        STORAGE ANALYSIS" -ForegroundColor Cyan
            Write-Host "================================================================" -ForegroundColor Cyan
            Write-Host "1. Disk partitions" -ForegroundColor White
            Write-Host "2. Disk usage" -ForegroundColor White
            Write-Host "3. Mount points" -ForegroundColor White
            Write-Host "4. Large files" -ForegroundColor White
            Write-Host "5. Disk health" -ForegroundColor White
            Write-Host "6. Storage pools" -ForegroundColor White
            Write-Host "7. File system info" -ForegroundColor White
            Write-Host "8. Disk performance" -ForegroundColor White
            Write-Host "0. Back to main menu" -ForegroundColor Yellow
            Write-Host "q. Exit Diagnostika" -ForegroundColor Yellow
            Write-Host ""
            $choice = Read-Host "Select command (1-8, 0, q)"
            
            switch ($choice) {
                "1" { 
                    Write-Host "🔧 Executing: Disk partitions" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-Partition | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "✅ Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "storage"
                }
                "2" { 
                    Write-Host "🔧 Executing: Disk usage" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-CimInstance -ClassName Win32_LogicalDisk | Select-Object DeviceID, Size, FreeSpace | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "✅ Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "storage"
                }
                "3" { 
                    Write-Host "🔧 Executing: Mount points" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-CimInstance -ClassName Win32_LogicalDisk | Select-Object DeviceID, VolumeName | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "✅ Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "storage"
                }
                "4" { 
                    Write-Host "🔧 Executing: Large files" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-ChildItem C:\ -Recurse -File -ErrorAction SilentlyContinue | Sort-Object Length -Descending | Select-Object -First 10 Name, Length | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "✅ Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "storage"
                }
                "5" { 
                    Write-Host "🔧 Executing: Disk health" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-CimInstance -ClassName Win32_DiskDrive | Select-Object Model, Status | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "✅ Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "storage"
                }
                "6" { 
                    Write-Host "🔧 Executing: Storage pools" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-StoragePool -ErrorAction SilentlyContinue | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "✅ Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "storage"
                }
                "7" { 
                    Write-Host "🔧 Executing: File system info" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-CimInstance -ClassName Win32_LogicalDisk | Select-Object DeviceID, FileSystem, VolumeName | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "✅ Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "storage"
                }
                "8" { 
                    Write-Host "🔧 Executing: Disk performance" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-Counter "\PhysicalDisk(*)\% Disk Time" -SampleInterval 1 -MaxSamples 3
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "✅ Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "storage"
                }
                "0" { Diagnostika }
                "q" { Write-Host "Goodbye!" -ForegroundColor Green; return }
                default { 
                    Write-Host "Invalid choice" -ForegroundColor Red
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "storage"
                }
            }
        }
        "security" {
            Write-Host "================================================================" -ForegroundColor Cyan
            Write-Host "                     SECURITY CHECK" -ForegroundColor Cyan
            Write-Host "================================================================" -ForegroundColor Cyan
            Write-Host "1. Open ports" -ForegroundColor White
            Write-Host "2. Listening services" -ForegroundColor White
            Write-Host "3. User accounts" -ForegroundColor White
            Write-Host "4. Local administrators" -ForegroundColor White
            Write-Host "5. Failed logins" -ForegroundColor White
            Write-Host "6. Windows Firewall" -ForegroundColor White
            Write-Host "7. Antivirus status" -ForegroundColor White
            Write-Host "8. Security events" -ForegroundColor White
            Write-Host "0. Back to main menu" -ForegroundColor Yellow
            Write-Host "q. Exit Diagnostika" -ForegroundColor Yellow
            Write-Host ""
            $choice = Read-Host "Select command (1-8, 0, q)"
            
            switch ($choice) {
                "1" { 
                    Write-Host "🔧 Executing: Open ports" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-NetTCPConnection | Where-Object {$_.State -eq "Listen"} | Select-Object -First 10 | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "✅ Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "security"
                }
                "2" { 
                    Write-Host "🔧 Executing: Listening services" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-Service | Where-Object {$_.Status -eq "Running"} | Select-Object -First 10 | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "✅ Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "security"
                }
                "3" { 
                    Write-Host "🔧 Executing: User accounts" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-LocalUser | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "✅ Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "security"
                }
                "4" { 
                    Write-Host "🔧 Executing: Local administrators" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-LocalGroupMember -Group "Administrators" | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "✅ Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "security"
                }
                "5" { 
                    Write-Host "🔧 Executing: Failed logins" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-WinEvent -LogName Security -FilterXPath "*[System[EventID=4625]]" -MaxEvents 10 | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "✅ Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "security"
                }
                "6" { 
                    Write-Host "🔧 Executing: Windows Firewall" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-NetFirewallProfile | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "✅ Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "security"
                }
                "7" { 
                    Write-Host "🔧 Executing: Antivirus status" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-CimInstance -Namespace root\SecurityCenter2 -ClassName AntiVirusProduct -ErrorAction SilentlyContinue | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "✅ Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "security"
                }
                "8" { 
                    Write-Host "🔧 Executing: Security events" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-WinEvent -LogName Security -MaxEvents 10 | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "✅ Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "security"
                }
                "0" { Diagnostika }
                "q" { Write-Host "Goodbye!" -ForegroundColor Green; return }
                default { 
                    Write-Host "Invalid choice" -ForegroundColor Red
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "security"
                }
            }
        }
        "performance" {
            Write-Host "================================================================" -ForegroundColor Cyan
            Write-Host "                  PERFORMANCE MONITORING" -ForegroundColor Cyan
            Write-Host "================================================================" -ForegroundColor Cyan
            Write-Host "1. CPU usage" -ForegroundColor White
            Write-Host "2. Memory usage" -ForegroundColor White
            Write-Host "3. System load" -ForegroundColor White
            Write-Host "4. Top processes" -ForegroundColor White
            Write-Host "5. Disk I/O" -ForegroundColor White
            Write-Host "6. Network usage" -ForegroundColor White
            Write-Host "7. System resources" -ForegroundColor White
            Write-Host "8. Performance counters" -ForegroundColor White
            Write-Host "0. Back to main menu" -ForegroundColor Yellow
            Write-Host "q. Exit Diagnostika" -ForegroundColor Yellow
            Write-Host ""
            $choice = Read-Host "Select command (1-8, 0, q)"
            
            switch ($choice) {
                "1" { 
                    Write-Host "🔧 Executing: CPU usage" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-Counter "\Processor(_Total)\% Processor Time" -SampleInterval 1 -MaxSamples 3
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "✅ Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "performance"
                }
                "2" { 
                    Write-Host "🔧 Executing: Memory usage" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-Counter "\Memory\Available MBytes" -SampleInterval 1 -MaxSamples 3
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "✅ Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "performance"
                }
                "3" { 
                    Write-Host "🔧 Executing: System load" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-CimInstance -ClassName Win32_Processor | Select-Object LoadPercentage | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "✅ Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "performance"
                }
                "4" { 
                    Write-Host "🔧 Executing: Top processes" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "✅ Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "performance"
                }
                "5" { 
                    Write-Host "🔧 Executing: Disk I/O" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-Counter "\PhysicalDisk(*)\% Disk Time" -SampleInterval 1 -MaxSamples 3
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "✅ Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "performance"
                }
                "6" { 
                    Write-Host "🔧 Executing: Network usage" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-Counter "\Network Interface(*)\Bytes Total/sec" -SampleInterval 1 -MaxSamples 3
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "✅ Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "performance"
                }
                "7" { 
                    Write-Host "🔧 Executing: System resources" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object TotalVisibleMemorySize, FreePhysicalMemory, TotalVirtualMemorySize, FreeVirtualMemory | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "✅ Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "performance"
                }
                "8" { 
                    Write-Host "🔧 Executing: Performance counters" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-Counter "\System\Processor Queue Length" -SampleInterval 1 -MaxSamples 3
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "✅ Command completed" -ForegroundColor Green
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "performance"
                }
                "0" { Diagnostika }
                "q" { Write-Host "Goodbye!" -ForegroundColor Green; return }
                default { 
                    Write-Host "Invalid choice" -ForegroundColor Red
                    Read-Host "Press Enter to continue"
                    Diagnostika-Windows "performance"
                }
            }
        }
        default {
            Write-Host "Unknown category: $Category" -ForegroundColor Red
            Write-Host "Available categories: network, system, storage, security, performance" -ForegroundColor Yellow
        }
    }
}

# Create aliases
Set-Alias -Name diag -Value Diagnostika
Set-Alias -Name help -Value Diagnostika
Set-Alias -Name menu -Value Diagnostika 