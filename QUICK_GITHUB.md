# 🚀 Быстрая загрузка в GitHub

## 📋 Быстрые шаги:

### 1. Создайте репозиторий на GitHub
- Имя: `diagnostika`
- Описание: `Универсальная система диагностики серверов`
- Public/Private: по выбору
- ✅ Add README
- ✅ Add .gitignore (Shell)
- ✅ MIT License

### 2. Загрузите файлы
**Вариант A: Через веб-интерфейс**
1. Нажмите "Add file" → "Upload files"
2. Перетащите ВСЕ файлы из папки `mc/`
3. Commit: `Initial commit: Diagnostika v2.0`

**Вариант B: Через Git**
```bash
git clone https://github.com/YOUR_USERNAME/diagnostika.git
cd diagnostika
cp -r /path/to/mc/* .
git add .
git commit -m "Initial commit: Diagnostika v2.0"
git push origin main
```

### 3. Обновите ссылки
В файлах `README.md` и `UNIVERSAL_SETUP.md` замените:
- `YOUR_USERNAME` → ваше имя пользователя GitHub

### 4. Проверьте работу
```bash
# Linux
curl -sSL https://raw.githubusercontent.com/YOUR_USERNAME/diagnostika/main/install.sh | bash

# PowerShell
Invoke-Expression (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/YOUR_USERNAME/diagnostika/main/install.ps1" -UseBasicParsing).Content
```

## 🎯 Готово!

Теперь пользователи смогут устанавливать Diagnostika одной командой!

**Подробная инструкция:** см. `GITHUB_SETUP.md` 