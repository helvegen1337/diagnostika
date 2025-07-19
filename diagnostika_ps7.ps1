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
            Write-Host ""
            $choice = Read-Host "Select command (1-8)"
            
            switch ($choice) {
                "1" { Get-NetAdapter }
                "2" { Get-NetTCPConnection | Select-Object -First 10 }
                "3" { Get-NetRoute | Select-Object -First 10 }
                "4" { Get-DnsClientServerAddress }
                "5" { Get-NetStatistics }
                "6" { Test-Connection -ComputerName "8.8.8.8" -Count 3 }
                "7" { Test-NetConnection -ComputerName "8.8.8.8" -TraceRoute }
                "8" { Write-Host "Bandwidth test not available in PowerShell" -ForegroundColor Yellow }
                default { Write-Host "Invalid choice" -ForegroundColor Red }
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
            Write-Host ""
            $choice = Read-Host "Select command (1-9)"
            
            switch ($choice) {
                "1" { Get-ComputerInfo | Select-Object WindowsProductName, WindowsVersion, TotalPhysicalMemory }
                "2" { Get-WmiObject -Class Win32_Processor | Select-Object Name, NumberOfCores, MaxClockSpeed }
                "3" { Get-WmiObject -Class Win32_OperatingSystem | Select-Object TotalVisibleMemorySize, FreePhysicalMemory }
                "4" { Get-WmiObject -Class Win32_LogicalDisk | Select-Object DeviceID, Size, FreeSpace }
                "5" { Get-WmiObject -Class Win32_Processor | Select-Object LoadPercentage }
                "6" { Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 }
                "7" { Get-Service | Where-Object {$_.Status -eq "Running"} | Select-Object -First 10 }
                "8" { Get-EventLog -LogName System -Newest 10 }
                "9" { [System.Environment]::OSVersion }
                default { Write-Host "Invalid choice" -ForegroundColor Red }
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
            Write-Host ""
            $choice = Read-Host "Select command (1-8)"
            
            switch ($choice) {
                "1" { Get-Partition }
                "2" { Get-WmiObject -Class Win32_LogicalDisk | Select-Object DeviceID, Size, FreeSpace }
                "3" { Get-WmiObject -Class Win32_LogicalDisk | Select-Object DeviceID, VolumeName }
                "4" { Get-ChildItem C:\ -Recurse -File | Sort-Object Length -Descending | Select-Object -First 10 Name, Length }
                "5" { Get-WmiObject -Class Win32_DiskDrive | Select-Object Model, Status }
                "6" { Get-StoragePool -ErrorAction SilentlyContinue }
                "7" { Get-WmiObject -Class Win32_LogicalDisk | Select-Object DeviceID, FileSystem, VolumeName }
                "8" { Get-Counter "\PhysicalDisk(*)\% Disk Time" -SampleInterval 1 -MaxSamples 3 }
                default { Write-Host "Invalid choice" -ForegroundColor Red }
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
            Write-Host ""
            $choice = Read-Host "Select command (1-8)"
            
            switch ($choice) {
                "1" { Get-NetTCPConnection | Where-Object {$_.State -eq "Listen"} | Select-Object -First 10 }
                "2" { Get-Service | Where-Object {$_.Status -eq "Running"} | Select-Object -First 10 }
                "3" { Get-LocalUser }
                "4" { Get-LocalGroupMember -Group "Administrators" }
                "5" { Get-EventLog -LogName Security -InstanceId 4625 -Newest 10 }
                "6" { Get-NetFirewallProfile }
                "7" { Get-WmiObject -Namespace root\SecurityCenter2 -Class AntiVirusProduct }
                "8" { Get-EventLog -LogName Security -Newest 10 }
                default { Write-Host "Invalid choice" -ForegroundColor Red }
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
            Write-Host ""
            $choice = Read-Host "Select command (1-8)"
            
            switch ($choice) {
                "1" { Get-Counter "\Processor(_Total)\% Processor Time" -SampleInterval 1 -MaxSamples 3 }
                "2" { Get-Counter "\Memory\Available MBytes" -SampleInterval 1 -MaxSamples 3 }
                "3" { Get-WmiObject -Class Win32_Processor | Select-Object LoadPercentage }
                "4" { Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 }
                "5" { Get-Counter "\PhysicalDisk(*)\% Disk Time" -SampleInterval 1 -MaxSamples 3 }
                "6" { Get-Counter "\Network Interface(*)\Bytes Total/sec" -SampleInterval 1 -MaxSamples 3 }
                "7" { Get-WmiObject -Class Win32_OperatingSystem | Select-Object TotalVisibleMemorySize, FreePhysicalMemory, TotalVirtualMemorySize, FreeVirtualMemory }
                "8" { Get-Counter "\System\Processor Queue Length" -SampleInterval 1 -MaxSamples 3 }
                default { Write-Host "Invalid choice" -ForegroundColor Red }
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