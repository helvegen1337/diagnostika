#!/bin/bash

echo "=== ТЕСТ УСТАНОВКИ DIAGNOSTIKA ==="
echo "Проверяем доступность файлов на GitHub..."

# Проверяем доступность установщика
echo "1. Проверяем установщик..."
if curl -sSL "https://raw.githubusercontent.com/helvegen1337/diagnostika/main/install.sh" > /dev/null; then
    echo "✅ Установщик доступен"
else
    echo "❌ Установщик недоступен"
    exit 1
fi

# Проверяем доступность console_function.sh
echo "2. Проверяем console_function.sh..."
if curl -sSL "https://raw.githubusercontent.com/helvegen1337/diagnostika/main/console_function.sh" > /dev/null; then
    echo "✅ console_function.sh доступен"
else
    echo "❌ console_function.sh недоступен"
    exit 1
fi

# Проверяем доступность diagnostika_v2.py
echo "3. Проверяем diagnostika_v2.py..."
if curl -sSL "https://raw.githubusercontent.com/helvegen1337/diagnostika/main/diagnostika_v2.py" > /dev/null; then
    echo "✅ diagnostika_v2.py доступен"
else
    echo "❌ diagnostika_v2.py недоступен"
    exit 1
fi

echo ""
echo "=== ВСЕ ФАЙЛЫ ДОСТУПНЫ ==="
echo "Теперь можно запускать установку:"
echo "curl -sSL https://raw.githubusercontent.com/helvegen1337/diagnostika/main/install.sh | bash" 