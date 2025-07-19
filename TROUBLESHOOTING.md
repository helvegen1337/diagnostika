# 🔧 Устранение неполадок установки Diagnostika

## ❌ Проблема: "cp: cannot stat 'console_function.sh': No such file or directory"

### 🔍 Диагностика проблемы

Если вы видите эту ошибку, это означает, что установщик пытается копировать локальные файлы вместо скачивания их с GitHub.

### ✅ Решение

#### 1. Проверьте доступность файлов на GitHub

Сначала запустите тестовый скрипт:

```bash
curl -sSL https://raw.githubusercontent.com/helvegen1337/diagnostika/main/test_install.sh | bash
```

#### 2. Очистите кэш и повторите установку

```bash
# Очистите кэш curl
rm -rf ~/.curl_cache 2>/dev/null || true

# Повторите установку
curl -sSL https://raw.githubusercontent.com/helvegen1337/diagnostika/main/install.sh | bash
```

#### 3. Альтернативный способ установки

Если проблема сохраняется, используйте альтернативный способ:

```bash
# Скачайте установщик
wget https://raw.githubusercontent.com/helvegen1337/diagnostika/main/install.sh

# Сделайте его исполняемым
chmod +x install.sh

# Запустите установку
./install.sh
```

### 🔧 Для PowerShell (Windows)

#### Проблема: "Cannot find path 'powershell_universal.ps1'"

#### Решение:

```powershell
# Очистите кэш PowerShell
Clear-Host

# Повторите установку
Invoke-Expression (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/helvegen1337/diagnostika/main/install.ps1" -UseBasicParsing).Content
```

### 🚨 Если ничего не помогает

#### 1. Проверьте интернет-соединение

```bash
# Проверьте доступность GitHub
ping -c 3 raw.githubusercontent.com

# Проверьте доступность через curl
curl -I https://raw.githubusercontent.com/helvegen1337/diagnostika/main/install.sh
```

#### 2. Проверьте DNS

```bash
# Проверьте разрешение DNS
nslookup raw.githubusercontent.com

# Попробуйте альтернативный DNS
curl -sSL --dns-servers 8.8.8.8 https://raw.githubusercontent.com/helvegen1337/diagnostika/main/install.sh | bash
```

#### 3. Ручная установка

Если автоматическая установка не работает, выполните установку вручную:

```bash
# Создайте директорию
mkdir -p ~/.diagnostika

# Скачайте файлы вручную
curl -sSL "https://raw.githubusercontent.com/helvegen1337/diagnostika/main/console_function.sh" -o ~/.diagnostika/console_function.sh
curl -sSL "https://raw.githubusercontent.com/helvegen1337/diagnostika/main/diagnostika_v2.py" -o ~/.diagnostika/diagnostika_v2.py

# Скачайте и запустите основной скрипт
curl -sSL "https://raw.githubusercontent.com/helvegen1337/diagnostika/main/install.sh" | tail -n +100 | bash
```

### 📞 Получение помощи

Если проблема не решается, предоставьте следующую информацию:

1. **Операционная система**: `uname -a` (Linux) или `systeminfo` (Windows)
2. **Версия curl**: `curl --version`
3. **Версия wget**: `wget --version` (если доступен)
4. **Полный вывод ошибки**
5. **Результат тестового скрипта**

### 🔄 Обновление установки

Для обновления существующей установки:

```bash
# Удалите старую установку
rm -rf ~/.diagnostika

# Удалите из профиля (если нужно)
sed -i '/diagnostika/d' ~/.bashrc

# Повторите установку
curl -sSL https://raw.githubusercontent.com/helvegen1337/diagnostika/main/install.sh | bash
```

---

**Примечание**: Установщики теперь скачивают файлы напрямую с GitHub, поэтому проблема с отсутствующими локальными файлами должна быть решена. Если вы все еще видите старые ошибки, попробуйте очистить кэш браузера или использовать другой терминал. 