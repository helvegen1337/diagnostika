# Diagnostika v2.0 - Установщик для PowerShell
# Автоматически добавляет функцию в профиль PowerShell

param(
    [switch]$Force,
    [switch]$Help
)

# Цвета для вывода
$Red = "Red"
$Green = "Green"
$Yellow = "Yellow"
$Blue = "Blue"
$White = "White"

function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

if ($Help) {
    Write-ColorOutput "Использование: .\install.ps1 [-Force] [-Help]" $Blue
    Write-ColorOutput "  -Force: Принудительная переустановка" $Yellow
    Write-ColorOutput "  -Help: Показать эту справку" $Yellow
    exit 0
}

Write-ColorOutput "╔══════════════════════════════════════════════════════════════════════════════════════════════════════════╗" $Blue
Write-ColorOutput "║                                   Diagnostika v2.0 - Установщик PowerShell                             ║" $Blue
Write-ColorOutput "╚══════════════════════════════════════════════════════════════════════════════════════════════════════════╝" $Blue

# Определяем профиль PowerShell
$ProfilePath = $PROFILE.CurrentUserAllHosts
$ProfileDir = Split-Path $ProfilePath -Parent

Write-ColorOutput "✅ Профиль PowerShell: $ProfilePath" $Green
Write-ColorOutput "✅ Директория профиля: $ProfileDir" $Green

# Создаем директорию для Diagnostika
$InstallDir = "$env:USERPROFILE\.diagnostika"
Write-ColorOutput "📁 Создаем директорию: $InstallDir" $Blue

if (!(Test-Path $InstallDir)) {
    New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
}

# Копируем файлы
Write-ColorOutput "📋 Копируем файлы..." $Blue
Copy-Item "powershell_universal.ps1" "$InstallDir\" -Force
Copy-Item "diagnostika_v2.py" "$InstallDir\" -Force

# Создаем основной скрипт PowerShell
$DiagnostikaScript = @'
# Diagnostika v2.0 - Основной скрипт PowerShell
# Автоматически определяет ОС и загружает соответствующие команды

# Определяем ОС
$OSInfo = Get-CimInstance -ClassName Win32_OperatingSystem
$OSName = $OSInfo.Caption
$OSVersion = $OSInfo.Version

# Функция диагностики с разделением по ОС
function Diagnostika {
    param([string]$Category = "")
    
    # Главное меню
    if (-not $Category) {
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
        Write-Host "Использование: Diagnostika <категория>" -ForegroundColor Yellow
        Write-Host "Примеры:" -ForegroundColor Yellow
        Write-Host "  Diagnostika network    - Диагностика сети" -ForegroundColor White
        Write-Host "  Diagnostika system     - Системная информация" -ForegroundColor White
        Write-Host "  Diagnostika storage    - Анализ хранилища" -ForegroundColor White
        Write-Host "  Diagnostika security   - Проверка безопасности" -ForegroundColor White
        Write-Host "  Diagnostika performance - Мониторинг производительности" -ForegroundColor White
        Write-Host "  Diagnostika docker     - Статус Docker" -ForegroundColor White
        Write-Host "  Diagnostika database   - Статус баз данных" -ForegroundColor White
        Write-Host "  Diagnostika web        - Веб-сервисы" -ForegroundColor White
        Write-Host "  Diagnostika backup     - Статус резервного копирования" -ForegroundColor White
        return
    }
    
    # Вызываем соответствующую функцию в зависимости от ОС
    Diagnostika-Windows "$@"
}

# Функция для Windows
function Diagnostika-Windows {
    param([string]$Category = "")
    
    switch ($Category.ToLower()) {
        "network" {
            Write-Host "╔══════════════════════════════════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
            Write-Host "║                                        ДИАГНОСТИКА СЕТИ (Windows)                                    ║" -ForegroundColor Cyan
            Write-Host "╚══════════════════════════════════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
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
            Write-Host "╔══════════════════════════════════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
            Write-Host "║                                     СИСТЕМНАЯ ИНФОРМАЦИЯ (Windows)                                   ║" -ForegroundColor Cyan
            Write-Host "╚══════════════════════════════════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
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
            Write-Host "╔══════════════════════════════════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
            Write-Host "║                                        АНАЛИЗ ХРАНИЛИЩА (Windows)                                   ║" -ForegroundColor Cyan
            Write-Host "╚══════════════════════════════════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
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
            Write-Host "╔══════════════════════════════════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
            Write-Host "║                                     ПРОВЕРКА БЕЗОПАСНОСТИ (Windows)                                 ║" -ForegroundColor Cyan
            Write-Host "╚══════════════════════════════════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
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
            Write-Host "╔══════════════════════════════════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
            Write-Host "║                                  МОНИТОРИНГ ПРОИЗВОДИТЕЛЬНОСТИ (Windows)                             ║" -ForegroundColor Cyan
            Write-Host "╚══════════════════════════════════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
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
        "docker" {
            Write-Host "╔══════════════════════════════════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
            Write-Host "║                                        СТАТУС DOCKER (Windows)                                      ║" -ForegroundColor Cyan
            Write-Host "╚══════════════════════════════════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
            Write-Host "1. Версия Docker" -ForegroundColor White
            Write-Host "2. Запущенные контейнеры" -ForegroundColor White
            Write-Host "3. Все контейнеры" -ForegroundColor White
            Write-Host "4. Образы Docker" -ForegroundColor White
            Write-Host "5. Информация о системе Docker" -ForegroundColor White
            Write-Host "6. Сети Docker" -ForegroundColor White
            Write-Host "7. Тома Docker" -ForegroundColor White
            Write-Host "8. Журналы Docker" -ForegroundColor White
            Write-Host ""
            $choice = Read-Host "Выберите команду (1-8)"
            
            switch ($choice) {
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
            Write-Host "╔══════════════════════════════════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
            Write-Host "║                                     СТАТУС БАЗ ДАННЫХ (Windows)                                     ║" -ForegroundColor Cyan
            Write-Host "╚══════════════════════════════════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
            Write-Host "1. Статус SQL Server" -ForegroundColor White
            Write-Host "2. Службы баз данных" -ForegroundColor White
            Write-Host "3. Соединения с базами данных" -ForegroundColor White
            Write-Host "4. Процессы баз данных" -ForegroundColor White
            Write-Host "5. Файлы баз данных" -ForegroundColor White
            Write-Host "6. Журналы баз данных" -ForegroundColor White
            Write-Host ""
            $choice = Read-Host "Выберите команду (1-6)"
            
            switch ($choice) {
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
            Write-Host "╔══════════════════════════════════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
            Write-Host "║                                        ВЕБ-СЕРВИСЫ (Windows)                                        ║" -ForegroundColor Cyan
            Write-Host "╚══════════════════════════════════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
            Write-Host "1. Статус IIS" -ForegroundColor White
            Write-Host "2. Конфигурация веб-сервера" -ForegroundColor White
            Write-Host "3. Журналы веб-сервера" -ForegroundColor White
            Write-Host "4. SSL-сертификаты" -ForegroundColor White
            Write-Host "5. Веб-порты" -ForegroundColor White
            Write-Host "6. Процессы веб-сервера" -ForegroundColor White
            Write-Host ""
            $choice = Read-Host "Выберите команду (1-6)"
            
            switch ($choice) {
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
            Write-Host "╔══════════════════════════════════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
            Write-Host "║                                   СТАТУС РЕЗЕРВНОГО КОПИРОВАНИЯ (Windows)                             ║" -ForegroundColor Cyan
            Write-Host "╚══════════════════════════════════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
            Write-Host "1. Службы резервного копирования" -ForegroundColor White
            Write-Host "2. Планировщик задач" -ForegroundColor White
            Write-Host "3. Недавние резервные копии" -ForegroundColor White
            Write-Host "4. Использование дисков для резервного копирования" -ForegroundColor White
            Write-Host "5. Процессы резервного копирования" -ForegroundColor White
            Write-Host "6. Резервное копирование Windows" -ForegroundColor White
            Write-Host ""
            $choice = Read-Host "Выберите команду (1-6)"
            
            switch ($choice) {
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
            Write-Host "Доступные категории: network, system, storage, security, performance, docker, database, web, backup" -ForegroundColor Yellow
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
'@

# Сохраняем скрипт
$DiagnostikaScript | Out-File -FilePath "$InstallDir\diagnostika.ps1" -Encoding UTF8

# Создаем профиль PowerShell если не существует
if (!(Test-Path $ProfilePath)) {
    New-Item -ItemType File -Path $ProfilePath -Force | Out-Null
    Write-ColorOutput "✅ Создан профиль PowerShell: $ProfilePath" $Green
}

# Добавляем в профиль PowerShell
$ProfileContent = Get-Content $ProfilePath -Raw
if ($ProfileContent -notlike "*diagnostika.ps1*") {
    Add-Content -Path $ProfilePath -Value ""
    Add-Content -Path $ProfilePath -Value "# Diagnostika v2.0 - Автоматическая загрузка"
    Add-Content -Path $ProfilePath -Value ". `"$InstallDir\diagnostika.ps1`""
    Write-ColorOutput "✅ Добавлено в профиль PowerShell: $ProfilePath" $Green
} else {
    Write-ColorOutput "⚠️  Diagnostika уже установлена в профиле PowerShell" $Yellow
}

Write-ColorOutput "" $White
Write-ColorOutput "🎉 Установка завершена!" $Green
Write-ColorOutput "" $White
Write-ColorOutput "📋 Что было сделано:" $Blue
Write-ColorOutput "  ✅ Создана директория: $InstallDir" $Green
Write-ColorOutput "  ✅ Скопированы файлы" $Green
Write-ColorOutput "  ✅ Создан основной скрипт PowerShell" $Green
Write-ColorOutput "  ✅ Добавлено в профиль: $ProfilePath" $Green
Write-ColorOutput "" $White
Write-ColorOutput "🚀 Использование:" $Blue
Write-ColorOutput "  Перезапустите PowerShell или выполните:" $White
Write-ColorOutput "  $Yellow. `"$InstallDir\diagnostika.ps1`"$White" $Yellow
Write-ColorOutput "" $White
Write-ColorOutput "🎮 Команды:" $Blue
Write-ColorOutput "  $Yellow diag$White           - Показать главное меню" $Yellow
Write-ColorOutput "  $Yellow diag network$White   - Диагностика сети" $Yellow
Write-ColorOutput "  $Yellow diag system$White    - Системная информация" $Yellow
Write-ColorOutput "  $Yellow diag storage$White   - Анализ хранилища" $Yellow
Write-ColorOutput "" $White
Write-ColorOutput "✨ Diagnostika v2.0 готова к использованию!" $Green 