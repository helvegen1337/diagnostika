# 🚀 Diagnostika v2.0 - Универсальная настройка

## 📋 Описание

**Diagnostika v2.0** - это универсальная система диагностики серверов, которая работает в любой консоли. Теперь с **постоянной установкой** - просто запустите установщик и используйте команду `diag`!

## 🎯 Основные возможности

✅ **Постоянная установка** - работает после перезагрузки  
✅ **Автоматическое определение ОС** - Linux/Windows команды  
✅ **Универсальность** - поддерживает Linux, Windows PowerShell, WSL  
✅ **Полный функционал** - 9 категорий диагностики  
✅ **Простота использования** - просто введите `diag`  
✅ **Разделение по ОС** - разные команды для Linux и Windows  

## 🚀 Быстрый старт

### Для Linux/Unix систем:

1. **Скачайте установщик:**
   ```bash
   wget https://raw.githubusercontent.com/your-repo/diagnostika/main/install.sh
   ```

2. **Запустите установку:**
   ```bash
   chmod +x install.sh
   ./install.sh
   ```

3. **Перезапустите терминал или выполните:**
   ```bash
   source ~/.bashrc
   ```

4. **Используйте команды:**
   ```bash
   diag network     # Диагностика сети
   diag system      # Системная информация
   diag storage     # Анализ хранилища
   ```

### Для PowerShell (Windows):

1. **Скачайте установщик:**
   ```powershell
   Invoke-WebRequest -Uri "https://raw.githubusercontent.com/your-repo/diagnostika/main/install.ps1" -OutFile "install.ps1"
   ```

2. **Запустите установку:**
   ```powershell
   .\install.ps1
   ```

3. **Перезапустите PowerShell или выполните:**
   ```powershell
   . $PROFILE
   ```

4. **Используйте команды:**
   ```powershell
   diag network     # Диагностика сети
   diag system      # Системная информация
   diag storage     # Анализ хранилища
   ```

## 📊 Доступные категории

| Категория | Linux | Windows | Описание |
|-----------|-------|---------|----------|
| 🌐 **network** | ✅ | ✅ | Диагностика сети |
| ⚙️ **system** | ✅ | ✅ | Системная информация |
| 💾 **storage** | ✅ | ✅ | Анализ хранилища |
| 🔒 **security** | ✅ | ✅ | Проверка безопасности |
| 📊 **performance** | ✅ | ✅ | Мониторинг производительности |
| 🐳 **docker** | ✅ | ✅ | Статус Docker |
| 🗄️ **database** | ✅ | ✅ | Статус баз данных |
| 🌍 **web** | ✅ | ✅ | Веб-сервисы |
| 💿 **backup** | ✅ | ✅ | Статус резервного копирования |

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
mc/
├── install.sh                 # Установщик для Linux/Unix
├── install.ps1                # Установщик для PowerShell
├── console_function.sh        # Bash функция (для копирования)
├── powershell_universal.ps1   # PowerShell функция (для копирования)
├── diagnostika_v2.py          # Основной Python модуль
├── UNIVERSAL_SETUP.md         # Эта инструкция
├── README.md                  # Основная документация
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
curl -sSL https://raw.githubusercontent.com/your-repo/diagnostika/main/install.sh | bash
```

#### PowerShell:
```powershell
# Скачать и запустить установщик
Invoke-Expression (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/your-repo/diagnostika/main/install.ps1" -UseBasicParsing).Content
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