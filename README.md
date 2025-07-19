# 🚀 Diagnostika v2.0 - Универсальная система диагностики

## 📋 Описание

**Diagnostika v2.0** - это универсальная система диагностики серверов с **постоянной установкой**. Работает в любой консоли - просто запустите установщик и используйте команду `diag`!

## 🎯 Основные возможности

✅ **Постоянная установка** - работает после перезагрузки  
✅ **Автоматическое определение ОС** - Linux/Windows команды  
✅ **Универсальность** - поддерживает Linux, Windows PowerShell, WSL  
✅ **Расширенный функционал** - 12 категорий диагностики  
✅ **Простота использования** - просто введите `diag`  
✅ **Разделение по ОС** - разные команды для Linux и Windows  

## 🚀 Быстрый старт

### Для Linux/Unix систем:

```bash
# Скачать и установить одной командой
curl -sSL https://raw.githubusercontent.com/YOUR_USERNAME/diagnostika/main/install.sh | bash

# Или вручную
wget https://raw.githubusercontent.com/YOUR_USERNAME/diagnostika/main/install.sh
chmod +x install.sh
./install.sh
```

### Для PowerShell (Windows):

```powershell
# Скачать и установить одной командой
Invoke-Expression (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/YOUR_USERNAME/diagnostika/main/install.ps1" -UseBasicParsing).Content

# Или вручную
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/YOUR_USERNAME/diagnostika/main/install.ps1" -OutFile "install.ps1"
.\install.ps1
```

## 📊 Доступные категории

| Категория | Linux | Windows | Команд | Описание |
|-----------|-------|---------|--------|----------|
| 🌐 **network** | ✅ | ✅ | 12/12 | Диагностика сети |
| ⚙️ **system** | ✅ | ✅ | 15/15 | Системная информация |
| 💾 **storage** | ✅ | ✅ | 12/12 | Анализ хранилища |
| 🔒 **security** | ✅ | ✅ | 12/12 | Проверка безопасности |
| 📊 **performance** | ✅ | ✅ | 12/12 | Мониторинг производительности |
| 🐳 **docker** | ✅ | ✅ | 12/12 | Статус Docker |
| 🗄️ **database** | ✅ | ✅ | 10/10 | Статус баз данных |
| 🌍 **web** | ✅ | ✅ | 10/10 | Веб-сервисы |
| 💿 **backup** | ✅ | ✅ | 8/8 | Статус резервного копирования |
| 🔧 **services** | ✅ | ✅ | 10/10 | Системные службы |
| 📱 **processes** | ✅ | ✅ | 10/10 | Процессы и процессы |
| 🌡️ **monitoring** | ✅ | ✅ | 8/8 | Мониторинг системы |

## 🎮 Примеры использования

### Диагностика сети:
```bash
# Linux/Unix
diag network

# PowerShell
diag network
```

### Системная информация:
```bash
# Linux/Unix
diag system

# PowerShell
diag system
```

### Анализ хранилища:
```bash
# Linux/Unix
diag storage

# PowerShell
diag storage
```

## 🔧 Команды

### Основные команды:
- `diag` - показать главное меню
- `help` - то же самое
- `menu` - то же самое

### Прямой доступ к категориям:
- `diag network` - диагностика сети
- `diag system` - системная информация
- `diag storage` - анализ хранилища
- `diag security` - проверка безопасности
- `diag performance` - мониторинг производительности
- `diag docker` - статус Docker
- `diag database` - статус баз данных
- `diag web` - веб-сервисы
- `diag backup` - статус резервного копирования
- `diag services` - системные службы
- `diag processes` - процессы и процессы
- `diag monitoring` - мониторинг системы

## 🌍 Поддерживаемые системы

### Linux/Unix:
- Ubuntu/Debian
- CentOS/RHEL
- Fedora
- Arch Linux
- Alpine Linux
- macOS (Terminal)

### Windows:
- PowerShell 5.1+
- PowerShell Core 6.0+
- Windows Terminal
- WSL (Windows Subsystem for Linux)

## 📁 Структура проекта

```
diagnostika/
├── install.sh                 # Установщик для Linux/Unix
├── install.ps1                # Установщик для PowerShell
├── console_function.sh        # Bash функция (для копирования)
├── powershell_universal.ps1   # PowerShell функция (для копирования)
├── diagnostika_v2.py          # Основной Python модуль
├── UNIVERSAL_SETUP.md         # Подробная инструкция
├── README.md                  # Эта документация
└── config/                    # Конфигурационные файлы
    ├── modules/               # Модули диагностики
    ├── plugins/               # Плагины
    └── core/                  # Основные компоненты
```

## 🔄 Установка

### Автоматическая установка (рекомендуется):

#### Linux/Unix:
```bash
# Скачать и запустить установщик
curl -sSL https://raw.githubusercontent.com/YOUR_USERNAME/diagnostika/main/install.sh | bash
```

#### PowerShell:
```powershell
# Скачать и запустить установщик
Invoke-Expression (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/YOUR_USERNAME/diagnostika/main/install.ps1" -UseBasicParsing).Content
```

### Ручная установка:

#### Linux/Unix:
1. Скачайте `install.sh`
2. Сделайте исполняемым: `chmod +x install.sh`
3. Запустите: `./install.sh`

#### PowerShell:
1. Скачайте `install.ps1`
2. Запустите: `.\install.ps1`

## 🛠️ Устранение неполадок

### Проблема: "Команда не найдена"
**Решение:** Убедитесь, что установка завершена. Выполните:
```bash
# Linux/Unix
source ~/.bashrc

# PowerShell
. $PROFILE
```

### Проблема: "Нет прав доступа"
**Решение:** Некоторые команды требуют sudo:
```bash
sudo diag system
```

### Проблема: "Функция не работает в новой сессии"
**Решение:** Проверьте, что установщик добавил функцию в профиль:
```bash
# Linux/Unix
cat ~/.bashrc | grep diagnostika

# PowerShell
Get-Content $PROFILE | Select-String "diagnostika"
```

### Проблема: "Ошибка при установке"
**Решение:** Запустите установщик с правами администратора:
```bash
# Linux/Unix
sudo ./install.sh

# PowerShell (запустите PowerShell от имени администратора)
.\install.ps1
```

## 🔧 Дополнительные возможности

### Модульная система:
- Поддержка пользовательских модулей
- Плагины для расширения функционала
- Конфигурационные файлы

### Автоматическое определение ОС:
- Linux команды для Linux/macOS
- Windows команды для PowerShell
- Автоматическое переключение

### Постоянная установка:
- Автоматическая загрузка при запуске консоли
- Работает во всех новых сессиях
- Не требует повторной установки

## 🤝 Поддержка

Если у вас возникли проблемы:

1. Проверьте версию вашей оболочки
2. Убедитесь, что установка завершена успешно
3. Проверьте права доступа
4. Обратитесь к документации

## 📄 Лицензия

Этот проект распространяется под лицензией MIT.

---

**🎉 Готово! Теперь диагностика доступна в любой консоли с постоянной установкой!** 