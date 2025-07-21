# Diagnostika v2.0 - Простой загрузчик
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