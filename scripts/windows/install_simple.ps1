# Diagnostika v2.0 - Простой установщик для PowerShell

param(
    [switch]$Force,
    [switch]$Help
)

if ($Help) {
    Write-Host "Использование: .\install_simple.ps1 [-Force] [-Help]" -ForegroundColor Blue
    Write-Host "  -Force: Принудительная переустановка" -ForegroundColor Yellow
    Write-Host "  -Help: Показать эту справку" -ForegroundColor Yellow
    exit 0
}

Write-Host "================================================================" -ForegroundColor Blue
Write-Host "                Diagnostika v2.0 - Установщик PowerShell" -ForegroundColor Blue
Write-Host "================================================================" -ForegroundColor Blue

# Определяем профиль PowerShell
$ProfilePath = $PROFILE.CurrentUserAllHosts
$ProfileDir = Split-Path $ProfilePath -Parent

Write-Host "Профиль PowerShell: $ProfilePath" -ForegroundColor Green
Write-Host "Директория профиля: $ProfileDir" -ForegroundColor Green

# Создаем директорию для Diagnostika
$InstallDir = "$env:USERPROFILE\.diagnostika"
Write-Host "Создаем директорию: $InstallDir" -ForegroundColor Blue

if (!(Test-Path $InstallDir)) {
    New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
}

# Скачиваем файлы с GitHub
Write-Host "Скачиваем файлы с GitHub..." -ForegroundColor Blue

Write-Host "Скачиваем diagnostika_ps7.ps1..." -ForegroundColor Blue
try {
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/helvegen1337/diagnostika/main/diagnostika_ps7.ps1" -OutFile "$InstallDir\powershell_universal.ps1" -UseBasicParsing
} catch {
    Write-Host "Ошибка: Не удалось скачать diagnostika_ps7.ps1" -ForegroundColor Red
    exit 1
}

Write-Host "Скачиваем diagnostika_v2.py..." -ForegroundColor Blue
try {
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/helvegen1337/diagnostika/main/diagnostika_v2.py" -OutFile "$InstallDir\diagnostika_v2.py" -UseBasicParsing
} catch {
    Write-Host "Ошибка: Не удалось скачать diagnostika_v2.py" -ForegroundColor Red
    exit 1
}

Write-Host "Все файлы успешно скачаны" -ForegroundColor Green

# Создаем основной скрипт PowerShell
$DiagnostikaScript = @'
# Diagnostika v2.0 - Основной скрипт PowerShell
# Загружает универсальную функцию из powershell_universal.ps1

# Загружаем универсальную функцию
$UniversalPath = "$env:USERPROFILE\.diagnostika\powershell_universal.ps1"
if (Test-Path $UniversalPath) {
    . $UniversalPath
} else {
    Write-Host "Error: Файл powershell_universal.ps1 не найден" -ForegroundColor Red
    Write-Host "Попробуйте переустановить Diagnostika" -ForegroundColor Yellow
}

# Создаем алиасы
Set-Alias -Name diag -Value Diagnostika
Set-Alias -Name help -Value Diagnostika
Set-Alias -Name menu -Value Diagnostika
'@

# Сохраняем скрипт
$DiagnostikaScript | Out-File -FilePath "$InstallDir\diagnostika.ps1" -Encoding UTF8

# Создаем тихий профиль PowerShell
$SilentProfileContent = @"
# Diagnostika v2.0 - Тихий профиль PowerShell
# Загружает функции без вывода информации

# Проверяем существование файла перед загрузкой
`$DiagnostikaPath = "`$env:USERPROFILE\.diagnostika\diagnostika.ps1"
if (Test-Path `$DiagnostikaPath) {
    # Загружаем тихо (без вывода)
    . `$DiagnostikaPath | Out-Null
}
"@

# Перезаписываем профиль тихой версией
$SilentProfileContent | Out-File -FilePath $ProfilePath -Encoding UTF8
Write-Host "Создан тихий профиль PowerShell: $ProfilePath" -ForegroundColor Green

Write-Host ""
Write-Host "Установка завершена!" -ForegroundColor Green
Write-Host ""
Write-Host "Что было сделано:" -ForegroundColor Blue
Write-Host "  Создана директория: $InstallDir" -ForegroundColor Green
Write-Host "  Скопированы файлы" -ForegroundColor Green
Write-Host "  Создан основной скрипт PowerShell" -ForegroundColor Green
Write-Host "  Создан тихий профиль: $ProfilePath" -ForegroundColor Green
Write-Host ""
Write-Host "Использование:" -ForegroundColor Blue
Write-Host "  Перезапустите PowerShell или выполните:" -ForegroundColor White
Write-Host "  . `"$InstallDir\diagnostika.ps1`"" -ForegroundColor Yellow
Write-Host ""
Write-Host "Команды:" -ForegroundColor Blue
Write-Host "  diag           - Показать главное меню" -ForegroundColor Yellow
Write-Host "  diag network   - Диагностика сети" -ForegroundColor Yellow
Write-Host "  diag system    - Системная информация" -ForegroundColor Yellow
Write-Host "  diag storage   - Анализ хранилища" -ForegroundColor Yellow
Write-Host ""
Write-Host "Diagnostika v2.0 готова к использованию!" -ForegroundColor Green 