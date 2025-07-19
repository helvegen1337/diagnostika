# Diagnostika v2.0 - Универсальная PowerShell функция
# Скопируйте и вставьте этот блок в любую PowerShell сессию

# Функция для отображения интерактивного меню
function Show-InteractiveMenu {
    param(
        [string]$Category,
        [string]$Title,
        [string[]]$Commands
    )
    
    do {
        Clear-Host
        Write-Host "╔══════════════════════════════════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
        Write-Host "║                                        $Title                                                          ║" -ForegroundColor Cyan
        Write-Host "╚══════════════════════════════════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
        
        # Отображаем команды
        for ($i = 0; $i -lt $Commands.Length; $i++) {
            Write-Host "$($i+1). $($Commands[$i])" -ForegroundColor White
        }
        
        Write-Host ""
        Write-Host "0. Вернуться в главное меню" -ForegroundColor Yellow
        Write-Host "q. Выйти из Diagnostika" -ForegroundColor Yellow
        Write-Host ""
        
        $choice = Read-Host "Выберите команду"
        
        switch ($choice) {
            "0" { return }
            "q" { Write-Host "До свидания!" -ForegroundColor Green; exit }
            { $_ -match '^\d+$' } {
                $index = [int]$choice - 1
                if ($index -ge 0 -and $index -lt $Commands.Length) {
                    Write-Host ""
                    Write-Host "🔧 Выполняю: $($Commands[$index])" -ForegroundColor Cyan
                    Write-Host "══════════════════════════════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Gray
                    
                    # Выполняем команду
                    Invoke-Command -Category $Category -Choice $choice
                    
                    Write-Host ""
                    Write-Host "══════════════════════════════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Gray
                    Write-Host "✅ Команда выполнена" -ForegroundColor Green
                    Write-Host ""
                    Read-Host "Нажмите Enter для продолжения"
                } else {
                    Write-Host "❌ Неверный выбор" -ForegroundColor Red
                    Start-Sleep -Seconds 2
                }
            }
            default {
                Write-Host "❌ Неверный выбор" -ForegroundColor Red
                Start-Sleep -Seconds 2
            }
        }
    } while ($true)
}

# Функция для выполнения команд
function Invoke-Command {
    param(
        [string]$Category,
        [string]$Choice
    )
    
    switch ($Category) {
        "network" {
            switch ($Choice) {
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
            switch ($Choice) {
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
            switch ($Choice) {
                "1" { Get-Partition }
                "2" { Get-WmiObject -Class Win32_LogicalDisk | Select-Object DeviceID, Size, FreeSpace, @{Name="Использовано(%)";Expression={[math]::Round((($_.Size-$_.FreeSpace)/$_.Size)*100,2)}} }
                "3" { Get-WmiObject -Class Win32_LogicalDisk | Select-Object DeviceID, VolumeName }
                "4" { Get-ChildItem C:\ -Recurse -File | Sort-Object Length -Descending | Select-Object -First 10 Name, @{Name="Размер(МБ)";Expression={[math]::Round($_.Length/1MB,2)}} }
                "5" { Get-WmiObject -Class Win32_DiskDrive | Select-Object Model, Status }
                "6" { Get-StoragePool -ErrorAction SilentlyContinue }
                "7" { Get-WmiObject -Class Win32_LogicalDisk | Select-Object DeviceID, FileSystem, VolumeName }
                "8" { Get-Counter "\PhysicalDisk(*)\% Disk Time" -SampleInterval 1 -MaxSamples 3 }
                default { Write-Host "Неверный выбор" -ForegroundColor Red }
            }
        }
        "security" {
            switch ($Choice) {
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
            switch ($Choice) {
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
        "docker" {
            switch ($Choice) {
                "1" { docker --version }
                "2" { docker ps }
                "3" { docker ps -a }
                "4" { docker images }
                "5" { docker system df }
                "6" { docker network ls }
                "7" { docker volume ls }
                "8" { Write-Host "Журналы Docker недоступны в PowerShell" -ForegroundColor Yellow }
                default { Write-Host "Неверный выбор" -ForegroundColor Red }
            }
        }
        "database" {
            switch ($Choice) {
                "1" { Get-Service -Name "*SQL*" }
                "2" { Get-Service | Where-Object {$_.Name -like "*SQL*" -or $_.Name -like "*MySQL*" -or $_.Name -like "*PostgreSQL*"} }
                "3" { Get-NetTCPConnection | Where-Object {$_.LocalPort -eq 1433 -or $_.LocalPort -eq 3306 -or $_.LocalPort -eq 5432} }
                "4" { Get-Process | Where-Object {$_.ProcessName -like "*sql*" -or $_.ProcessName -like "*mysql*" -or $_.ProcessName -like "*postgres*"} }
                "5" { Get-ChildItem C:\ -Recurse -Include "*.mdf","*.ldf","*.db" -ErrorAction SilentlyContinue | Select-Object -First 10 }
                "6" { Write-Host "Журналы баз данных недоступны в PowerShell" -ForegroundColor Yellow }
                default { Write-Host "Неверный выбор" -ForegroundColor Red }
            }
        }
        "web" {
            switch ($Choice) {
                "1" { Get-Service -Name "*IIS*" }
                "2" { Get-IISAppPool }
                "3" { Get-ChildItem C:\inetpub\logs\LogFiles -Recurse -File | Select-Object -First 10 }
                "4" { Get-ChildItem Cert:\LocalMachine\My }
                "5" { Get-NetTCPConnection | Where-Object {$_.LocalPort -eq 80 -or $_.LocalPort -eq 443 -or $_.LocalPort -eq 8080} }
                "6" { Get-Process | Where-Object {$_.ProcessName -like "*w3wp*" -or $_.ProcessName -like "*iis*"} }
                default { Write-Host "Неверный выбор" -ForegroundColor Red }
            }
        }
        "backup" {
            switch ($Choice) {
                "1" { Get-Service | Where-Object {$_.Name -like "*backup*" -or $_.Name -like "*vss*"} }
                "2" { Get-ScheduledTask | Where-Object {$_.TaskName -like "*backup*"} }
                "3" { Get-ChildItem C:\ -Recurse -Include "*.bak","*.backup" -ErrorAction SilentlyContinue | Select-Object -First 10 }
                "4" { Get-WmiObject -Class Win32_LogicalDisk | Where-Object {$_.VolumeName -like "*backup*"} }
                "5" { Get-Process | Where-Object {$_.ProcessName -like "*backup*" -or $_.ProcessName -like "*vss*"} }
                "6" { Get-WBBackupTarget }
                default { Write-Host "Неверный выбор" -ForegroundColor Red }
            }
        }
        default {
            Write-Host "Неизвестная категория: $Category" -ForegroundColor Red
        }
    }
}

# Основная функция Diagnostika с интерактивным меню
function Diagnostika {
    param([Parameter(ValueFromRemainingArguments=$true)][string[]]$Category)
    
    # Объединяем все аргументы в одну строку
    $CategoryString = $Category -join " "
    
    # Главное меню
    if (-not $CategoryString) {
        do {
            Clear-Host
            Write-Host "╔══════════════════════════════════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
            Write-Host "║                                   Diagnostika v2.0 - Универсальная система                               ║" -ForegroundColor Cyan
            Write-Host "╚══════════════════════════════════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
            Write-Host "                         Доступные категории" -ForegroundColor White
            Write-Host "╭──────────────────────────────┬────────────┬────────────────╮" -ForegroundColor White
            Write-Host "│   🌐 Диагностика сети        │ 📁 Меню    │ 8 команд       │" -ForegroundColor White
            Write-Host "│   ⚙️ Системная информация    │ 📁 Меню    │ 9 команд       │" -ForegroundColor White
            Write-Host "│   💾 Анализ хранилища       │ 📁 Меню    │ 8 команд       │" -ForegroundColor White
            Write-Host "│   🔒 Проверка безопасности  │ 📁 Меню    │ 8 команд       │" -ForegroundColor White
            Write-Host "│   📊 Мониторинг производительности │ 📁 Меню │ 8 команд       │" -ForegroundColor White
            Write-Host "│   🐳 Статус Docker          │ 📁 Меню    │ 8 команд       │" -ForegroundColor White
            Write-Host "│   🗄️ Статус баз данных      │ 📁 Меню    │ 6 команд       │" -ForegroundColor White
            Write-Host "│   🌍 Веб-сервисы            │ 📁 Меню    │ 6 команд       │" -ForegroundColor White
            Write-Host "│   💿 Статус резервного копирования │ 📁 Меню │ 6 команд       │" -ForegroundColor White
            Write-Host "╰──────────────────────────────┴────────────┴────────────────╯" -ForegroundColor White
            Write-Host ""
            Write-Host "0. Выйти из Diagnostika" -ForegroundColor Yellow
            Write-Host ""
            
            $choice = Read-Host "Выберите категорию"
            
            switch ($choice) {
                "0" { Write-Host "До свидания!" -ForegroundColor Green; exit }
                "1" { 
                    Show-InteractiveMenu -Category "network" -Title "ДИАГНОСТИКА СЕТИ" -Commands @(
                        "Сетевые интерфейсы",
                        "Сетевые соединения", 
                        "Таблица маршрутизации",
                        "Конфигурация DNS",
                        "Статистика сети",
                        "Тест пинга",
                        "Трассировка маршрута",
                        "Тест пропускной способности"
                    )
                }
                "2" {
                    Show-InteractiveMenu -Category "system" -Title "СИСТЕМНАЯ ИНФОРМАЦИЯ" -Commands @(
                        "Информация о системе",
                        "Информация о процессоре",
                        "Информация о памяти",
                        "Использование дисков",
                        "Загрузка системы",
                        "Топ процессов",
                        "Статус служб",
                        "Системные журналы",
                        "Версия Windows"
                    )
                }
                "3" {
                    Show-InteractiveMenu -Category "storage" -Title "АНАЛИЗ ХРАНИЛИЩА" -Commands @(
                        "Разделы дисков",
                        "Использование дисков",
                        "Точки монтирования",
                        "Большие файлы",
                        "Здоровье дисков",
                        "Пространства хранения",
                        "Информация о файловой системе",
                        "Производительность дисков"
                    )
                }
                "4" {
                    Show-InteractiveMenu -Category "security" -Title "ПРОВЕРКА БЕЗОПАСНОСТИ" -Commands @(
                        "Открытые порты",
                        "Службы прослушивания",
                        "Пользовательские учетные записи",
                        "Локальные администраторы",
                        "Неудачные входы",
                        "Брандмауэр Windows",
                        "Статус антивируса",
                        "События безопасности"
                    )
                }
                "5" {
                    Show-InteractiveMenu -Category "performance" -Title "МОНИТОРИНГ ПРОИЗВОДИТЕЛЬНОСТИ" -Commands @(
                        "Использование процессора",
                        "Использование памяти",
                        "Загрузка системы",
                        "Топ процессов",
                        "Ввод-вывод дисков",
                        "Использование сети",
                        "Системные ресурсы",
                        "Счетчики производительности"
                    )
                }
                "6" {
                    Show-InteractiveMenu -Category "docker" -Title "СТАТУС DOCKER" -Commands @(
                        "Версия Docker",
                        "Запущенные контейнеры",
                        "Все контейнеры",
                        "Образы Docker",
                        "Информация о системе Docker",
                        "Сети Docker",
                        "Тома Docker",
                        "Журналы Docker"
                    )
                }
                "7" {
                    Show-InteractiveMenu -Category "database" -Title "СТАТУС БАЗ ДАННЫХ" -Commands @(
                        "Статус SQL Server",
                        "Службы баз данных",
                        "Соединения с базами данных",
                        "Процессы баз данных",
                        "Файлы баз данных",
                        "Журналы баз данных"
                    )
                }
                "8" {
                    Show-InteractiveMenu -Category "web" -Title "ВЕБ-СЕРВИСЫ" -Commands @(
                        "Статус IIS",
                        "Конфигурация веб-сервера",
                        "Журналы веб-сервера",
                        "SSL-сертификаты",
                        "Веб-порты",
                        "Процессы веб-сервера"
                    )
                }
                "9" {
                    Show-InteractiveMenu -Category "backup" -Title "СТАТУС РЕЗЕРВНОГО КОПИРОВАНИЯ" -Commands @(
                        "Службы резервного копирования",
                        "Планировщик задач",
                        "Недавние резервные копии",
                        "Использование дисков для резервного копирования",
                        "Процессы резервного копирования",
                        "Резервное копирование Windows"
                    )
                }
                default {
                    Write-Host "❌ Неверный выбор" -ForegroundColor Red
                    Start-Sleep -Seconds 2
                }
            }
        } while ($true)
    } else {
        # Прямой вызов категории (для обратной совместимости)
        switch ($CategoryString.ToLower()) {
            "network" {
                Show-InteractiveMenu -Category "network" -Title "ДИАГНОСТИКА СЕТИ" -Commands @(
                    "Сетевые интерфейсы",
                    "Сетевые соединения", 
                    "Таблица маршрутизации",
                    "Конфигурация DNS",
                    "Статистика сети",
                    "Тест пинга",
                    "Трассировка маршрута",
                    "Тест пропускной способности"
                )
            }
            "system" {
                Show-InteractiveMenu -Category "system" -Title "СИСТЕМНАЯ ИНФОРМАЦИЯ" -Commands @(
                    "Информация о системе",
                    "Информация о процессоре",
                    "Информация о памяти",
                    "Использование дисков",
                    "Загрузка системы",
                    "Топ процессов",
                    "Статус служб",
                    "Системные журналы",
                    "Версия Windows"
                )
            }
            "storage" {
                Show-InteractiveMenu -Category "storage" -Title "АНАЛИЗ ХРАНИЛИЩА" -Commands @(
                    "Разделы дисков",
                    "Использование дисков",
                    "Точки монтирования",
                    "Большие файлы",
                    "Здоровье дисков",
                    "Пространства хранения",
                    "Информация о файловой системе",
                    "Производительность дисков"
                )
            }
            "security" {
                Show-InteractiveMenu -Category "security" -Title "ПРОВЕРКА БЕЗОПАСНОСТИ" -Commands @(
                    "Открытые порты",
                    "Службы прослушивания",
                    "Пользовательские учетные записи",
                    "Локальные администраторы",
                    "Неудачные входы",
                    "Брандмауэр Windows",
                    "Статус антивируса",
                    "События безопасности"
                )
            }
            "performance" {
                Show-InteractiveMenu -Category "performance" -Title "МОНИТОРИНГ ПРОИЗВОДИТЕЛЬНОСТИ" -Commands @(
                    "Использование процессора",
                    "Использование памяти",
                    "Загрузка системы",
                    "Топ процессов",
                    "Ввод-вывод дисков",
                    "Использование сети",
                    "Системные ресурсы",
                    "Счетчики производительности"
                )
            }
            "docker" {
                Show-InteractiveMenu -Category "docker" -Title "СТАТУС DOCKER" -Commands @(
                    "Версия Docker",
                    "Запущенные контейнеры",
                    "Все контейнеры",
                    "Образы Docker",
                    "Информация о системе Docker",
                    "Сети Docker",
                    "Тома Docker",
                    "Журналы Docker"
                )
            }
            "database" {
                Show-InteractiveMenu -Category "database" -Title "СТАТУС БАЗ ДАННЫХ" -Commands @(
                    "Статус SQL Server",
                    "Службы баз данных",
                    "Соединения с базами данных",
                    "Процессы баз данных",
                    "Файлы баз данных",
                    "Журналы баз данных"
                )
            }
            "web" {
                Show-InteractiveMenu -Category "web" -Title "ВЕБ-СЕРВИСЫ" -Commands @(
                    "Статус IIS",
                    "Конфигурация веб-сервера",
                    "Журналы веб-сервера",
                    "SSL-сертификаты",
                    "Веб-порты",
                    "Процессы веб-сервера"
                )
            }
            "backup" {
                Show-InteractiveMenu -Category "backup" -Title "СТАТУС РЕЗЕРВНОГО КОПИРОВАНИЯ" -Commands @(
                    "Службы резервного копирования",
                    "Планировщик задач",
                    "Недавние резервные копии",
                    "Использование дисков для резервного копирования",
                    "Процессы резервного копирования",
                    "Резервное копирование Windows"
                )
            }
            default {
                Write-Host "Неизвестная категория: $CategoryString" -ForegroundColor Red
                Write-Host "Доступные категории: network, system, storage, security, performance, docker, database, web, backup" -ForegroundColor Yellow
            }
        }
    }
}

# Создаем алиасы
Set-Alias -Name diag -Value Diagnostika
Set-Alias -Name help -Value Diagnostika
Set-Alias -Name menu -Value Diagnostika

Write-Host "✅ Diagnostika v2.0 PowerShell функция загружена!" -ForegroundColor Green
Write-Host "Доступные команды:" -ForegroundColor Yellow
Write-Host "  Diagnostika    - Показать главное меню" -ForegroundColor White
Write-Host "  diag           - То же самое (сокращение)" -ForegroundColor White
Write-Host "  help           - То же самое" -ForegroundColor White
Write-Host "  menu           - То же самое" -ForegroundColor White
Write-Host ""
Write-Host "Быстрый доступ:" -ForegroundColor Yellow
Write-Host "  diag network   - Диагностика сети" -ForegroundColor White
Write-Host "  diag system    - Системная информация" -ForegroundColor White
Write-Host "  diag storage   - Анализ хранилища" -ForegroundColor White
Write-Host "  diag security  - Проверка безопасности" -ForegroundColor White
Write-Host "  diag performance - Мониторинг производительности" -ForegroundColor White
Write-Host ""
Write-Host "Использование: Просто введите 'diag' или 'help' для начала!" -ForegroundColor Green 