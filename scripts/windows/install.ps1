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

# Скачиваем файлы с GitHub
Write-ColorOutput "📋 Скачиваем файлы с GitHub..." $Blue

Write-ColorOutput "📥 Скачиваем powershell_universal.ps1..." $Blue
try {
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/helvegen1337/diagnostika/main/scripts/windows/powershell_universal.ps1" -OutFile "$InstallDir\powershell_universal.ps1" -UseBasicParsing
} catch {
    Write-ColorOutput "❌ Ошибка: Не удалось скачать powershell_universal.ps1" $Red
    exit 1
}

Write-ColorOutput "📥 Скачиваем diagnostika_v2.py..." $Blue
try {
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/helvegen1337/diagnostika/main/checklist/diagnostika_v2.py" -OutFile "$InstallDir\diagnostika_v2.py" -UseBasicParsing
} catch {
    Write-ColorOutput "❌ Ошибка: Не удалось скачать diagnostika_v2.py" $Red
    exit 1
}

Write-ColorOutput "✅ Все файлы успешно скачаны" $Green

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
Write-ColorOutput "✅ Создан тихий профиль PowerShell: $ProfilePath" $Green

Write-ColorOutput "" $White
Write-ColorOutput "🎉 Установка завершена!" $Green
Write-ColorOutput "" $White
Write-ColorOutput "📋 Что было сделано:" $Blue
Write-ColorOutput "  ✅ Создана директория: $InstallDir" $Green
Write-ColorOutput "  ✅ Скопированы файлы" $Green
Write-ColorOutput "  ✅ Создан основной скрипт PowerShell" $Green
Write-ColorOutput "  ✅ Создан тихий профиль: $ProfilePath" $Green
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