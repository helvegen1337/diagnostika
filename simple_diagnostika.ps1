# Diagnostika v2.0 - Простая версия для PowerShell
# Универсальная система диагностики

function Diagnostika {
    param([Parameter(ValueFromRemainingArguments=$true)][string[]]$Category)
    
    # Объединяем все аргументы в одну строку
    $CategoryString = $Category -join " "
    
    # Главное меню
    if (-not $CategoryString) {
        Write-Host "================================================================" -ForegroundColor Cyan
        Write-Host "                Diagnostika v2.0 - Универсальная система" -ForegroundColor Cyan
        Write-Host "================================================================" -ForegroundColor Cyan
        Write-Host "                         Доступные категории" -ForegroundColor White
        Write-Host "1. Диагностика сети" -ForegroundColor White
        Write-Host "2. Системная информация" -ForegroundColor White
        Write-Host "3. Анализ хранилища" -ForegroundColor White
        Write-Host "4. Проверка безопасности" -ForegroundColor White
        Write-Host "5. Мониторинг производительности" -ForegroundColor White
        Write-Host "6. Статус Docker" -ForegroundColor White
        Write-Host "7. Статус баз данных" -ForegroundColor White
        Write-Host "8. Веб-сервисы" -ForegroundColor White
        Write-Host "9. Статус резервного копирования" -ForegroundColor White
        Write-Host ""
        Write-Host "Использование: Diagnostika <категория>" -ForegroundColor Yellow
        Write-Host "Примеры:" -ForegroundColor Yellow
        Write-Host "  Diagnostika network    - Диагностика сети" -ForegroundColor White
        Write-Host "  Diagnostika system     - Системная информация" -ForegroundColor White
        Write-Host "  Diagnostika storage    - Анализ хранилища" -ForegroundColor White
        Write-Host "  Diagnostika security   - Проверка безопасности" -ForegroundColor White
        Write-Host "  Diagnostika performance - Мониторинг производительности" -ForegroundColor White
        return
    }
    
    # Вызываем соответствующую функцию
    Diagnostika-Windows $CategoryString
}

# Функция для Windows
function Diagnostika-Windows {
    param([string]$Category = "")
    
    switch ($Category.ToLower()) {
        "network" {
            Write-Host "================================================================" -ForegroundColor Cyan
            Write-Host "                        ДИАГНОСТИКА СЕТИ" -ForegroundColor Cyan
            Write-Host "================================================================" -ForegroundColor Cyan
            Write-Host "1. Сетевые интерфейсы" -ForegroundColor White
            Write-Host "2. Сетевые соединения" -ForegroundColor White
            Write-Host "3. Таблица маршрутизации" -ForegroundColor White
            Write-Host "4. Конфигурация DNS" -ForegroundColor White
            Write-Host "5. Статистика сети" -ForegroundColor White
            Write-Host "6. Тест пинга" -ForegroundColor White
            Write-Host "7. Трассировка маршрута" -ForegroundColor White
            Write-Host "8. Тест пропускной способности" -ForegroundColor White
            Write-Host ""
            $choice = Read-Host "Выберите команду (1-8)"
            
            switch ($choice) {
                "1" { Get-NetAdapter }
                "2" { Get-NetTCPConnection | Select-Object -First 10 }
                "3" { Get-NetRoute | Select-Object -First 10 }
                "4" { Get-DnsClientServerAddress }
                "5" { Get-NetStatistics }
                "6" { Test-Connection -ComputerName "8.8.8.8" -Count 3 }
                "7" { Test-NetConnection -ComputerName "8.8.8.8" -TraceRoute }
                "8" { Write-Host "Тест пропускной способности недоступен в PowerShell" -ForegroundColor Yellow }
                default { Write-Host "Неверный выбор" -ForegroundColor Red }
            }
        }
        "system" {
            Write-Host "================================================================" -ForegroundColor Cyan
            Write-Host "                     СИСТЕМНАЯ ИНФОРМАЦИЯ" -ForegroundColor Cyan
            Write-Host "================================================================" -ForegroundColor Cyan
            Write-Host "1. Информация о системе" -ForegroundColor White
            Write-Host "2. Информация о процессоре" -ForegroundColor White
            Write-Host "3. Информация о памяти" -ForegroundColor White
            Write-Host "4. Использование дисков" -ForegroundColor White
            Write-Host "5. Загрузка системы" -ForegroundColor White
            Write-Host "6. Топ процессов" -ForegroundColor White
            Write-Host "7. Статус служб" -ForegroundColor White
            Write-Host "8. Системные журналы" -ForegroundColor White
            Write-Host "9. Версия Windows" -ForegroundColor White
            Write-Host ""
            $choice = Read-Host "Выберите команду (1-9)"
            
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
                default { Write-Host "Неверный выбор" -ForegroundColor Red }
            }
        }
        "storage" {
            Write-Host "================================================================" -ForegroundColor Cyan
            Write-Host "                        АНАЛИЗ ХРАНИЛИЩА" -ForegroundColor Cyan
            Write-Host "================================================================" -ForegroundColor Cyan
            Write-Host "1. Разделы дисков" -ForegroundColor White
            Write-Host "2. Использование дисков" -ForegroundColor White
            Write-Host "3. Точки монтирования" -ForegroundColor White
            Write-Host "4. Большие файлы" -ForegroundColor White
            Write-Host "5. Здоровье дисков" -ForegroundColor White
            Write-Host "6. Пространства хранения" -ForegroundColor White
            Write-Host "7. Информация о файловой системе" -ForegroundColor White
            Write-Host "8. Производительность дисков" -ForegroundColor White
            Write-Host ""
            $choice = Read-Host "Выберите команду (1-8)"
            
            switch ($choice) {
                "1" { Get-Partition }
                "2" { Get-WmiObject -Class Win32_LogicalDisk | Select-Object DeviceID, Size, FreeSpace }
                "3" { Get-WmiObject -Class Win32_LogicalDisk | Select-Object DeviceID, VolumeName }
                "4" { Get-ChildItem C:\ -Recurse -File | Sort-Object Length -Descending | Select-Object -First 10 Name, Length }
                "5" { Get-WmiObject -Class Win32_DiskDrive | Select-Object Model, Status }
                "6" { Get-StoragePool -ErrorAction SilentlyContinue }
                "7" { Get-WmiObject -Class Win32_LogicalDisk | Select-Object DeviceID, FileSystem, VolumeName }
                "8" { Get-Counter "\PhysicalDisk(*)\% Disk Time" -SampleInterval 1 -MaxSamples 3 }
                default { Write-Host "Неверный выбор" -ForegroundColor Red }
            }
        }
        "security" {
            Write-Host "================================================================" -ForegroundColor Cyan
            Write-Host "                     ПРОВЕРКА БЕЗОПАСНОСТИ" -ForegroundColor Cyan
            Write-Host "================================================================" -ForegroundColor Cyan
            Write-Host "1. Открытые порты" -ForegroundColor White
            Write-Host "2. Службы прослушивания" -ForegroundColor White
            Write-Host "3. Пользовательские учетные записи" -ForegroundColor White
            Write-Host "4. Локальные администраторы" -ForegroundColor White
            Write-Host "5. Неудачные входы" -ForegroundColor White
            Write-Host "6. Брандмауэр Windows" -ForegroundColor White
            Write-Host "7. Статус антивируса" -ForegroundColor White
            Write-Host "8. События безопасности" -ForegroundColor White
            Write-Host ""
            $choice = Read-Host "Выберите команду (1-8)"
            
            switch ($choice) {
                "1" { Get-NetTCPConnection | Where-Object {$_.State -eq "Listen"} | Select-Object -First 10 }
                "2" { Get-Service | Where-Object {$_.Status -eq "Running"} | Select-Object -First 10 }
                "3" { Get-LocalUser }
                "4" { Get-LocalGroupMember -Group "Administrators" }
                "5" { Get-EventLog -LogName Security -InstanceId 4625 -Newest 10 }
                "6" { Get-NetFirewallProfile }
                "7" { Get-WmiObject -Namespace root\SecurityCenter2 -Class AntiVirusProduct }
                "8" { Get-EventLog -LogName Security -Newest 10 }
                default { Write-Host "Неверный выбор" -ForegroundColor Red }
            }
        }
        "performance" {
            Write-Host "================================================================" -ForegroundColor Cyan
            Write-Host "                  МОНИТОРИНГ ПРОИЗВОДИТЕЛЬНОСТИ" -ForegroundColor Cyan
            Write-Host "================================================================" -ForegroundColor Cyan
            Write-Host "1. Использование процессора" -ForegroundColor White
            Write-Host "2. Использование памяти" -ForegroundColor White
            Write-Host "3. Загрузка системы" -ForegroundColor White
            Write-Host "4. Топ процессов" -ForegroundColor White
            Write-Host "5. Ввод-вывод дисков" -ForegroundColor White
            Write-Host "6. Использование сети" -ForegroundColor White
            Write-Host "7. Системные ресурсы" -ForegroundColor White
            Write-Host "8. Счетчики производительности" -ForegroundColor White
            Write-Host ""
            $choice = Read-Host "Выберите команду (1-8)"
            
            switch ($choice) {
                "1" { Get-Counter "\Processor(_Total)\% Processor Time" -SampleInterval 1 -MaxSamples 3 }
                "2" { Get-Counter "\Memory\Available MBytes" -SampleInterval 1 -MaxSamples 3 }
                "3" { Get-WmiObject -Class Win32_Processor | Select-Object LoadPercentage }
                "4" { Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 }
                "5" { Get-Counter "\PhysicalDisk(*)\% Disk Time" -SampleInterval 1 -MaxSamples 3 }
                "6" { Get-Counter "\Network Interface(*)\Bytes Total/sec" -SampleInterval 1 -MaxSamples 3 }
                "7" { Get-WmiObject -Class Win32_OperatingSystem | Select-Object TotalVisibleMemorySize, FreePhysicalMemory, TotalVirtualMemorySize, FreeVirtualMemory }
                "8" { Get-Counter "\System\Processor Queue Length" -SampleInterval 1 -MaxSamples 3 }
                default { Write-Host "Неверный выбор" -ForegroundColor Red }
            }
        }
        default {
            Write-Host "Неизвестная категория: $Category" -ForegroundColor Red
            Write-Host "Доступные категории: network, system, storage, security, performance" -ForegroundColor Yellow
        }
    }
}
    }
}

# Создаем алиасы
Set-Alias -Name diag -Value Diagnostika
Set-Alias -Name help -Value Diagnostika
Set-Alias -Name menu -Value Diagnostika 