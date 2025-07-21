# Diagnostika v2.0 - Полностью русифицированная версия PowerShell
# Универсальная система диагностики

function Diagnostika {
    param([Parameter(ValueFromRemainingArguments=$true)][string[]]$Category)
    
    # Определяем ОС и версию PowerShell
    $os = (Get-CimInstance Win32_OperatingSystem).Caption
    $psver = $PSVersionTable.PSVersion.ToString()
    $categories = @(
        @{num=1; name='Диагностика сети'; key='network'},
        @{num=2; name='Системная информация'; key='system'},
        @{num=3; name='Анализ хранилища'; key='storage'},
        @{num=4; name='Проверка безопасности'; key='security'},
        @{num=5; name='Мониторинг производительности'; key='performance'}
    )
    
    $CategoryString = $Category -join " "
    
    if (-not $CategoryString) {
        Write-Host "================================================================" -ForegroundColor Cyan
        Write-Host "                Diagnostika v2.0 - Универсальная система" -ForegroundColor Cyan
        Write-Host "================================================================" -ForegroundColor Cyan
        Write-Host (" ОС: {0}" -f $os) -ForegroundColor Yellow
        Write-Host (" Версия PowerShell: {0}" -f $psver) -ForegroundColor Yellow
        Write-Host "================================================================" -ForegroundColor Cyan
        Write-Host "                         Доступные категории" -ForegroundColor White
        foreach ($cat in $categories) {
            Write-Host ("{0}. {1}" -f $cat.num, $cat.name) -ForegroundColor White
        }
        Write-Host ""
        Write-Host "[Поиск] Введите часть названия категории для фильтрации или нажмите Enter для показа всех." -ForegroundColor DarkGray
        $search = Read-Host "Поиск категории (или Enter для всех)"
        if ($search) {
            $filtered = $categories | Where-Object { $_.name -like "*${search}*" }
            if ($filtered.Count -eq 0) {
                Write-Host "Нет совпадений. Показываю все категории." -ForegroundColor Yellow
            } else {
                Write-Host "Результаты поиска:" -ForegroundColor Green
                foreach ($cat in $filtered) {
                    Write-Host ("{0}. {1}" -f $cat.num, $cat.name) -ForegroundColor Green
                }
                Write-Host ""
            }
        }
        Write-Host "Использование: Diagnostika <категория> или номер" -ForegroundColor Yellow
        Write-Host "Примеры:" -ForegroundColor Yellow
        Write-Host "  Diagnostika network    - Диагностика сети" -ForegroundColor White
        Write-Host "  Diagnostika system     - Системная информация" -ForegroundColor White
        Write-Host "  Diagnostika storage    - Анализ хранилища" -ForegroundColor White
        Write-Host "  Diagnostika security   - Проверка безопасности" -ForegroundColor White
        Write-Host "  Diagnostika performance - Мониторинг производительности" -ForegroundColor White
        Write-Host "6. Проверить обновления" -ForegroundColor White
        Write-Host "7. Запустить несколько проверок подряд" -ForegroundColor White
        return
    }
    
    # Если пользователь ввёл номер категории, преобразуем в ключ
    if ($CategoryString -match '^[1-5]$') {
        $cat = $categories | Where-Object { $_.num -eq [int]$CategoryString }
        if ($cat) { $CategoryString = $cat.key }
    }
    
    Diagnostika-Windows $CategoryString
}

# Функция для Windows
function Diagnostika-Windows {
    param([string]$Category = "")
    switch ($Category.ToLower()) {
        "network" { Invoke-NetworkChecks }
        "system" { Invoke-SystemChecks }
        "storage" { Invoke-StorageChecks }
        "security" { Invoke-SecurityChecks }
        "performance" { Invoke-PerformanceChecks }
        default {
            Write-Host "Неизвестная категория: $Category" -ForegroundColor Red
            Write-Host "Доступные категории: network, system, storage, security, performance" -ForegroundColor Yellow
        }
    }
}

function Invoke-NetworkChecks {
    param()
    # Весь код из case 'network' переносится сюда
}
function Invoke-SystemChecks {
    param()
    # Весь код из case 'system' переносится сюда
}
function Invoke-StorageChecks {
    param()
    # Весь код из case 'storage' переносится сюда
}
function Invoke-SecurityChecks {
    param()
    # Весь код из case 'security' переносится сюда
}
function Invoke-PerformanceChecks {
    param()
    # Весь код из case 'performance' переносится сюда
}

# Создаем алиасы
Set-Alias -Name diag -Value Diagnostika
Set-Alias -Name help -Value Diagnostika
Set-Alias -Name menu -Value Diagnostika 