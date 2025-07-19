# Diagnostika v2.0 - Полностью русифицированная версия PowerShell
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
            Write-Host "2. Сетевые подключения" -ForegroundColor White
            Write-Host "3. Таблица маршрутизации" -ForegroundColor White
            Write-Host "4. Конфигурация DNS" -ForegroundColor White
            Write-Host "5. Сетевая статистика" -ForegroundColor White
            Write-Host "6. Тест ping" -ForegroundColor White
            Write-Host "7. Трассировка маршрута" -ForegroundColor White
            Write-Host "8. Тест пропускной способности" -ForegroundColor White
            Write-Host "0. Вернуться в главное меню" -ForegroundColor Yellow
            Write-Host "q. Выйти из Diagnostika" -ForegroundColor Yellow
            Write-Host ""
            $choice = Read-Host "Выберите команду (1-8, 0, q)"
            
            switch ($choice) {
                "1" { 
                    Write-Host "Выполняю: Сетевые интерфейсы" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-NetAdapter | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Команда выполнена" -ForegroundColor Green
                    Read-Host "Нажмите Enter для продолжения"
                    Diagnostika-Windows "network"
                }
                "2" { 
                    Write-Host "Выполняю: Сетевые подключения" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-NetTCPConnection | Select-Object -First 10 | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Команда выполнена" -ForegroundColor Green
                    Read-Host "Нажмите Enter для продолжения"
                    Diagnostika-Windows "network"
                }
                "3" { 
                    Write-Host "Выполняю: Таблица маршрутизации" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-NetRoute | Select-Object -First 10 | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Команда выполнена" -ForegroundColor Green
                    Read-Host "Нажмите Enter для продолжения"
                    Diagnostika-Windows "network"
                }
                "4" { 
                    Write-Host "Выполняю: Конфигурация DNS" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-DnsClientServerAddress | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Команда выполнена" -ForegroundColor Green
                    Read-Host "Нажмите Enter для продолжения"
                    Diagnostika-Windows "network"
                }
                "5" { 
                    Write-Host "Выполняю: Сетевая статистика" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-NetStatistics | Select-Object -First 10 | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Команда выполнена" -ForegroundColor Green
                    Read-Host "Нажмите Enter для продолжения"
                    Diagnostika-Windows "network"
                }
                "6" { 
                    Write-Host "Выполняю: Тест ping" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Test-Connection -ComputerName "8.8.8.8" -Count 3
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Команда выполнена" -ForegroundColor Green
                    Read-Host "Нажмите Enter для продолжения"
                    Diagnostika-Windows "network"
                }
                "7" { 
                    Write-Host "Выполняю: Трассировка маршрута" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Test-NetConnection -ComputerName "8.8.8.8" -TraceRoute
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Команда выполнена" -ForegroundColor Green
                    Read-Host "Нажмите Enter для продолжения"
                    Diagnostika-Windows "network"
                }
                "8" { 
                    Write-Host "Выполняю: Тест пропускной способности" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Тест пропускной способности недоступен в PowerShell" -ForegroundColor Yellow
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Команда выполнена" -ForegroundColor Green
                    Read-Host "Нажмите Enter для продолжения"
                    Diagnostika-Windows "network"
                }
                "0" { Diagnostika }
                "q" { Write-Host "До свидания!" -ForegroundColor Green; return }
                default { 
                    Write-Host "Неверный выбор" -ForegroundColor Red
                    Read-Host "Нажмите Enter для продолжения"
                    Diagnostika-Windows "network"
                }
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
            Write-Host "0. Вернуться в главное меню" -ForegroundColor Yellow
            Write-Host "q. Выйти из Diagnostika" -ForegroundColor Yellow
            Write-Host ""
            $choice = Read-Host "Выберите команду (1-9, 0, q)"
            
            switch ($choice) {
                "1" { 
                    Write-Host "Выполняю: Информация о системе" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-ComputerInfo | Select-Object WindowsProductName, WindowsVersion, TotalPhysicalMemory | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Команда выполнена" -ForegroundColor Green
                    Read-Host "Нажмите Enter для продолжения"
                    Diagnostika-Windows "system"
                }
                "2" { 
                    Write-Host "Выполняю: Информация о процессоре" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-CimInstance -ClassName Win32_Processor | Select-Object Name, NumberOfCores, MaxClockSpeed | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Команда выполнена" -ForegroundColor Green
                    Read-Host "Нажмите Enter для продолжения"
                    Diagnostika-Windows "system"
                }
                "3" { 
                    Write-Host "Выполняю: Информация о памяти" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object TotalVisibleMemorySize, FreePhysicalMemory | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Команда выполнена" -ForegroundColor Green
                    Read-Host "Нажмите Enter для продолжения"
                    Diagnostika-Windows "system"
                }
                "4" { 
                    Write-Host "Выполняю: Использование дисков" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-CimInstance -ClassName Win32_LogicalDisk | Select-Object DeviceID, Size, FreeSpace | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Команда выполнена" -ForegroundColor Green
                    Read-Host "Нажмите Enter для продолжения"
                    Diagnostika-Windows "system"
                }
                "5" { 
                    Write-Host "Выполняю: Загрузка системы" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-CimInstance -ClassName Win32_Processor | Select-Object LoadPercentage | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Команда выполнена" -ForegroundColor Green
                    Read-Host "Нажмите Enter для продолжения"
                    Diagnostika-Windows "system"
                }
                "6" { 
                    Write-Host "Выполняю: Топ процессов" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Команда выполнена" -ForegroundColor Green
                    Read-Host "Нажмите Enter для продолжения"
                    Diagnostika-Windows "system"
                }
                "7" { 
                    Write-Host "Выполняю: Статус служб" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-Service | Where-Object {$_.Status -eq "Running"} | Select-Object -First 10 | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Команда выполнена" -ForegroundColor Green
                    Read-Host "Нажмите Enter для продолжения"
                    Diagnostika-Windows "system"
                }
                "8" { 
                    Write-Host "Выполняю: Системные журналы" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-WinEvent -LogName System -MaxEvents 10 | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Команда выполнена" -ForegroundColor Green
                    Read-Host "Нажмите Enter для продолжения"
                    Diagnostika-Windows "system"
                }
                "9" { 
                    Write-Host "Выполняю: Версия Windows" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    [System.Environment]::OSVersion
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Команда выполнена" -ForegroundColor Green
                    Read-Host "Нажмите Enter для продолжения"
                    Diagnostika-Windows "system"
                }
                "0" { Diagnostika }
                "q" { Write-Host "До свидания!" -ForegroundColor Green; return }
                default { 
                    Write-Host "Неверный выбор" -ForegroundColor Red
                    Read-Host "Нажмите Enter для продолжения"
                    Diagnostika-Windows "system"
                }
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
            Write-Host "6. Пулы хранилища" -ForegroundColor White
            Write-Host "7. Информация о файловой системе" -ForegroundColor White
            Write-Host "8. Производительность дисков" -ForegroundColor White
            Write-Host "0. Вернуться в главное меню" -ForegroundColor Yellow
            Write-Host "q. Выйти из Diagnostika" -ForegroundColor Yellow
            Write-Host ""
            $choice = Read-Host "Выберите команду (1-8, 0, q)"
            
            switch ($choice) {
                "1" { 
                    Write-Host "Выполняю: Разделы дисков" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-Partition | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Команда выполнена" -ForegroundColor Green
                    Read-Host "Нажмите Enter для продолжения"
                    Diagnostika-Windows "storage"
                }
                "2" { 
                    Write-Host "Выполняю: Использование дисков" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-CimInstance -ClassName Win32_LogicalDisk | Select-Object DeviceID, Size, FreeSpace | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Команда выполнена" -ForegroundColor Green
                    Read-Host "Нажмите Enter для продолжения"
                    Diagnostika-Windows "storage"
                }
                "3" { 
                    Write-Host "Выполняю: Точки монтирования" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-CimInstance -ClassName Win32_LogicalDisk | Select-Object DeviceID, VolumeName | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Команда выполнена" -ForegroundColor Green
                    Read-Host "Нажмите Enter для продолжения"
                    Diagnostika-Windows "storage"
                }
                "4" { 
                    Write-Host "Выполняю: Большие файлы" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-ChildItem C:\ -Recurse -File -ErrorAction SilentlyContinue | Sort-Object Length -Descending | Select-Object -First 10 Name, Length | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Команда выполнена" -ForegroundColor Green
                    Read-Host "Нажмите Enter для продолжения"
                    Diagnostika-Windows "storage"
                }
                "5" { 
                    Write-Host "Выполняю: Здоровье дисков" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-CimInstance -ClassName Win32_DiskDrive | Select-Object Model, Status | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Команда выполнена" -ForegroundColor Green
                    Read-Host "Нажмите Enter для продолжения"
                    Diagnostika-Windows "storage"
                }
                "6" { 
                    Write-Host "Выполняю: Пулы хранилища" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-StoragePool -ErrorAction SilentlyContinue | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Команда выполнена" -ForegroundColor Green
                    Read-Host "Нажмите Enter для продолжения"
                    Diagnostika-Windows "storage"
                }
                "7" { 
                    Write-Host "Выполняю: Информация о файловой системе" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-CimInstance -ClassName Win32_LogicalDisk | Select-Object DeviceID, FileSystem, VolumeName | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Команда выполнена" -ForegroundColor Green
                    Read-Host "Нажмите Enter для продолжения"
                    Diagnostika-Windows "storage"
                }
                "8" { 
                    Write-Host "Выполняю: Производительность дисков" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-Counter "\PhysicalDisk(*)\% Disk Time" -SampleInterval 1 -MaxSamples 3
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Команда выполнена" -ForegroundColor Green
                    Read-Host "Нажмите Enter для продолжения"
                    Diagnostika-Windows "storage"
                }
                "0" { Diagnostika }
                "q" { Write-Host "До свидания!" -ForegroundColor Green; return }
                default { 
                    Write-Host "Неверный выбор" -ForegroundColor Red
                    Read-Host "Нажмите Enter для продолжения"
                    Diagnostika-Windows "storage"
                }
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
            Write-Host "0. Вернуться в главное меню" -ForegroundColor Yellow
            Write-Host "q. Выйти из Diagnostika" -ForegroundColor Yellow
            Write-Host ""
            $choice = Read-Host "Выберите команду (1-8, 0, q)"
            
            switch ($choice) {
                "1" { 
                    Write-Host "Выполняю: Открытые порты" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-NetTCPConnection | Where-Object {$_.State -eq "Listen"} | Select-Object -First 10 | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Команда выполнена" -ForegroundColor Green
                    Read-Host "Нажмите Enter для продолжения"
                    Diagnostika-Windows "security"
                }
                "2" { 
                    Write-Host "Выполняю: Службы прослушивания" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-Service | Where-Object {$_.Status -eq "Running"} | Select-Object -First 10 | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Команда выполнена" -ForegroundColor Green
                    Read-Host "Нажмите Enter для продолжения"
                    Diagnostika-Windows "security"
                }
                "3" { 
                    Write-Host "Выполняю: Пользовательские учетные записи" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-LocalUser | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Команда выполнена" -ForegroundColor Green
                    Read-Host "Нажмите Enter для продолжения"
                    Diagnostika-Windows "security"
                }
                "4" { 
                    Write-Host "Выполняю: Локальные администраторы" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-LocalGroupMember -Group "Administrators" | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Команда выполнена" -ForegroundColor Green
                    Read-Host "Нажмите Enter для продолжения"
                    Diagnostika-Windows "security"
                }
                "5" { 
                    Write-Host "Выполняю: Неудачные входы" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-WinEvent -LogName Security -FilterXPath "*[System[EventID=4625]]" -MaxEvents 10 | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Команда выполнена" -ForegroundColor Green
                    Read-Host "Нажмите Enter для продолжения"
                    Diagnostika-Windows "security"
                }
                "6" { 
                    Write-Host "Выполняю: Брандмауэр Windows" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-NetFirewallProfile | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Команда выполнена" -ForegroundColor Green
                    Read-Host "Нажмите Enter для продолжения"
                    Diagnostika-Windows "security"
                }
                "7" { 
                    Write-Host "Выполняю: Статус антивируса" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-CimInstance -Namespace root\SecurityCenter2 -ClassName AntiVirusProduct -ErrorAction SilentlyContinue | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Команда выполнена" -ForegroundColor Green
                    Read-Host "Нажмите Enter для продолжения"
                    Diagnostika-Windows "security"
                }
                "8" { 
                    Write-Host "Выполняю: События безопасности" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-WinEvent -LogName Security -MaxEvents 10 | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Команда выполнена" -ForegroundColor Green
                    Read-Host "Нажмите Enter для продолжения"
                    Diagnostika-Windows "security"
                }
                "0" { Diagnostika }
                "q" { Write-Host "До свидания!" -ForegroundColor Green; return }
                default { 
                    Write-Host "Неверный выбор" -ForegroundColor Red
                    Read-Host "Нажмите Enter для продолжения"
                    Diagnostika-Windows "security"
                }
            }
        }
        "performance" {
            Write-Host "================================================================" -ForegroundColor Cyan
            Write-Host "                  МОНИТОРИНГ ПРОИЗВОДИТЕЛЬНОСТИ" -ForegroundColor Cyan
            Write-Host "================================================================" -ForegroundColor Cyan
            Write-Host "1. Использование CPU" -ForegroundColor White
            Write-Host "2. Использование памяти" -ForegroundColor White
            Write-Host "3. Загрузка системы" -ForegroundColor White
            Write-Host "4. Топ процессов" -ForegroundColor White
            Write-Host "5. Ввод-вывод дисков" -ForegroundColor White
            Write-Host "6. Использование сети" -ForegroundColor White
            Write-Host "7. Системные ресурсы" -ForegroundColor White
            Write-Host "8. Счетчики производительности" -ForegroundColor White
            Write-Host "0. Вернуться в главное меню" -ForegroundColor Yellow
            Write-Host "q. Выйти из Diagnostika" -ForegroundColor Yellow
            Write-Host ""
            $choice = Read-Host "Выберите команду (1-8, 0, q)"
            
            switch ($choice) {
                "1" { 
                    Write-Host "Выполняю: Использование CPU" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-Counter "\Processor(_Total)\% Processor Time" -SampleInterval 1 -MaxSamples 3
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Команда выполнена" -ForegroundColor Green
                    Read-Host "Нажмите Enter для продолжения"
                    Diagnostika-Windows "performance"
                }
                "2" { 
                    Write-Host "Выполняю: Использование памяти" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-Counter "\Memory\Available MBytes" -SampleInterval 1 -MaxSamples 3
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Команда выполнена" -ForegroundColor Green
                    Read-Host "Нажмите Enter для продолжения"
                    Diagnostika-Windows "performance"
                }
                "3" { 
                    Write-Host "Выполняю: Загрузка системы" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-CimInstance -ClassName Win32_Processor | Select-Object LoadPercentage | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Команда выполнена" -ForegroundColor Green
                    Read-Host "Нажмите Enter для продолжения"
                    Diagnostika-Windows "performance"
                }
                "4" { 
                    Write-Host "Выполняю: Топ процессов" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Команда выполнена" -ForegroundColor Green
                    Read-Host "Нажмите Enter для продолжения"
                    Diagnostika-Windows "performance"
                }
                "5" { 
                    Write-Host "Выполняю: Ввод-вывод дисков" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-Counter "\PhysicalDisk(*)\% Disk Time" -SampleInterval 1 -MaxSamples 3
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Команда выполнена" -ForegroundColor Green
                    Read-Host "Нажмите Enter для продолжения"
                    Diagnostika-Windows "performance"
                }
                "6" { 
                    Write-Host "Выполняю: Использование сети" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-Counter "\Network Interface(*)\Bytes Total/sec" -SampleInterval 1 -MaxSamples 3
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Команда выполнена" -ForegroundColor Green
                    Read-Host "Нажмите Enter для продолжения"
                    Diagnostika-Windows "performance"
                }
                "7" { 
                    Write-Host "Выполняю: Системные ресурсы" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object TotalVisibleMemorySize, FreePhysicalMemory, TotalVirtualMemorySize, FreeVirtualMemory | Format-Table -AutoSize
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Команда выполнена" -ForegroundColor Green
                    Read-Host "Нажмите Enter для продолжения"
                    Diagnostika-Windows "performance"
                }
                "8" { 
                    Write-Host "Выполняю: Счетчики производительности" -ForegroundColor Green
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Get-Counter "\System\Processor Queue Length" -SampleInterval 1 -MaxSamples 3
                    Write-Host "================================================================" -ForegroundColor Cyan
                    Write-Host "Команда выполнена" -ForegroundColor Green
                    Read-Host "Нажмите Enter для продолжения"
                    Diagnostika-Windows "performance"
                }
                "0" { Diagnostika }
                "q" { Write-Host "До свидания!" -ForegroundColor Green; return }
                default { 
                    Write-Host "Неверный выбор" -ForegroundColor Red
                    Read-Host "Нажмите Enter для продолжения"
                    Diagnostika-Windows "performance"
                }
            }
        }
        default {
            Write-Host "Неизвестная категория: $Category" -ForegroundColor Red
            Write-Host "Доступные категории: network, system, storage, security, performance" -ForegroundColor Yellow
        }
    }
}

# Создаем алиасы
Set-Alias -Name diag -Value Diagnostika
Set-Alias -Name help -Value Diagnostika
Set-Alias -Name menu -Value Diagnostika 