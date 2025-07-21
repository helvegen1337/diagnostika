# 🚀 Настройка GitHub репозитория для Diagnostika v2.0

## 📋 Пошаговая инструкция

### 1. Создание репозитория на GitHub

1. **Перейдите на GitHub.com** и войдите в свой аккаунт
2. **Нажмите "New repository"** (зеленая кнопка)
3. **Заполните форму:**
   - Repository name: `diagnostika`
   - Description: `Универсальная система диагностики серверов с постоянной установкой`
   - Visibility: Public (или Private по желанию)
   - ✅ Add a README file
   - ✅ Add .gitignore (выберите "Shell")
   - ✅ Choose a license (MIT)

### 2. Загрузка файлов

#### Вариант A: Через веб-интерфейс GitHub

1. **Перейдите в созданный репозиторий**
2. **Нажмите "Add file" → "Upload files"**
3. **Перетащите все файлы из папки `mc/`:**
   ```
   install.sh
   install.ps1
   console_function.sh
   powershell_universal.ps1
   diagnostika_v2.py
   UNIVERSAL_SETUP.md
   README.md
   config/ (папка)
   modules/ (папка)
   plugins/ (папка)
   core/ (папка)
   ```
4. **Добавьте сообщение коммита:** `Initial commit: Diagnostika v2.0`
5. **Нажмите "Commit changes"**

#### Вариант B: Через Git командную строку

```bash
# Клонируйте репозиторий
git clone https://github.com/YOUR_USERNAME/diagnostika.git
cd diagnostika

# Скопируйте все файлы
cp -r /path/to/mc/* .

# Добавьте файлы в Git
git add .

# Создайте коммит
git commit -m "Initial commit: Diagnostika v2.0"

# Отправьте на GitHub
git push origin main
```

### 3. Обновление ссылок в файлах

После загрузки файлов нужно обновить ссылки в документации:

#### В файле `README.md`:
Замените `YOUR_USERNAME` на ваше имя пользователя GitHub:

```bash
# Было:
curl -sSL https://raw.githubusercontent.com/YOUR_USERNAME/diagnostika/main/install.sh | bash

# Стало:
curl -sSL https://raw.githubusercontent.com/helvegen1337/diagnostika/main/install.sh | bash
```

#### В файле `UNIVERSAL_SETUP.md`:
Аналогично замените все ссылки.

### 4. Проверка работоспособности

После загрузки проверьте, что файлы доступны:

```bash
# Проверка Linux установщика
curl -I https://raw.githubusercontent.com/helvegen1337/diagnostika/main/install.sh

# Проверка PowerShell установщика
curl -I https://raw.githubusercontent.com/helvegen1337/diagnostika/main/install.ps1
```

### 5. Тестирование установки

#### Linux/Unix:
```bash
# Тест установки
curl -sSL https://raw.githubusercontent.com/helvegen1337/diagnostika/main/install.sh | bash
```

#### PowerShell:
```powershell
# Тест установки
Invoke-Expression (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/helvegen1337/diagnostika/main/install.ps1" -UseBasicParsing).Content
```

## 📁 Структура репозитория

После загрузки структура должна выглядеть так:

```
diagnostika/
├── README.md                  # Основная документация
├── UNIVERSAL_SETUP.md         # Подробная инструкция
├── GITHUB_SETUP.md           # Эта инструкция
├── install.sh                 # Установщик для Linux/Unix
├── install.ps1                # Установщик для PowerShell
├── console_function.sh        # Bash функция
├── powershell_universal.ps1   # PowerShell функция
├── diagnostika_v2.py          # Основной Python модуль
├── .gitignore                 # Исключения Git
├── LICENSE                    # Лицензия MIT
└── config/                    # Конфигурационные файлы
    ├── modules/               # Модули диагностики
    ├── plugins/               # Плагины
    └── core/                  # Основные компоненты
```

## 🔗 Полезные ссылки

### Для пользователей:
- **Linux/Unix:** `curl -sSL https://raw.githubusercontent.com/helvegen1337/diagnostika/main/install.sh | bash`
- **PowerShell:** `Invoke-Expression (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/helvegen1337/diagnostika/main/install.ps1" -UseBasicParsing).Content`

### Для разработчиков:
- **Репозиторий:** `https://github.com/helvegen1337/diagnostika`
- **Issues:** `https://github.com/helvegen1337/diagnostika/issues`
- **Releases:** `https://github.com/helvegen1337/diagnostika/releases`

## 🎯 Дополнительные настройки

### 1. Настройка GitHub Pages (опционально)

Для создания веб-страницы с документацией:

1. **Перейдите в Settings → Pages**
2. **Source:** Deploy from a branch
3. **Branch:** main
4. **Folder:** / (root)
5. **Нажмите Save**

### 2. Настройка Actions (опционально)

Создайте файл `.github/workflows/test.yml` для автоматического тестирования:

```yaml
name: Test Diagnostika

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: Test Linux installer
      run: |
        chmod +x install.sh
        ./install.sh --help
    - name: Test PowerShell installer
      run: |
        pwsh -Command ".\install.ps1 -Help"
```

### 3. Создание Release

Для стабильных версий:

1. **Перейдите в Releases**
2. **Нажмите "Create a new release"**
3. **Tag version:** v2.0.0
4. **Release title:** Diagnostika v2.0
5. **Description:** Описание изменений
6. **Загрузите файлы:** install.sh, install.ps1

## 🚀 Готово!

После выполнения всех шагов у вас будет:

✅ **Публичный репозиторий** с полным функционалом  
✅ **Рабочие ссылки** для скачивания через curl  
✅ **Документация** для пользователей  
✅ **Возможность обновлений** через Git  

### Использование:

Пользователи смогут устанавливать Diagnostika одной командой:

```bash
# Linux/Unix
curl -sSL https://raw.githubusercontent.com/helvegen1337/diagnostika/main/install.sh | bash

# PowerShell
Invoke-Expression (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/helvegen1337/diagnostika/main/install.ps1" -UseBasicParsing).Content
```

**🎉 Поздравляем! Diagnostika v2.0 готова к использованию!** 