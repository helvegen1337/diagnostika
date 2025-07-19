#!/bin/bash

# Diagnostika v2.0 - Установщик для Linux/Unix
# Автоматически добавляет функцию в профиль оболочки

set -e

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔══════════════════════════════════════════════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                                   Diagnostika v2.0 - Установщик Linux/Unix                              ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════════════════════════════════════════════════════╝${NC}"

# Определяем текущую оболочку
SHELL_TYPE=""
SHELL_RC=""

if [ -n "$ZSH_VERSION" ]; then
    SHELL_TYPE="zsh"
    SHELL_RC="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
    SHELL_TYPE="bash"
    SHELL_RC="$HOME/.bashrc"
else
    # Пытаемся определить оболочку
    if [ -f "$HOME/.zshrc" ]; then
        SHELL_TYPE="zsh"
        SHELL_RC="$HOME/.zshrc"
    elif [ -f "$HOME/.bashrc" ]; then
        SHELL_TYPE="bash"
        SHELL_RC="$HOME/.bashrc"
    else
        echo -e "${RED}❌ Не удалось определить тип оболочки${NC}"
        echo -e "${YELLOW}Попробуйте запустить: bash install.sh${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}✅ Обнаружена оболочка: ${SHELL_TYPE}${NC}"
echo -e "${GREEN}✅ Файл профиля: ${SHELL_RC}${NC}"

# Создаем директорию для Diagnostika
INSTALL_DIR="$HOME/.diagnostika"
echo -e "${BLUE}📁 Создаем директорию: ${INSTALL_DIR}${NC}"
mkdir -p "$INSTALL_DIR"

# Копируем файлы
echo -e "${BLUE}📋 Скачиваем файлы с GitHub...${NC}"

# Скачиваем необходимые файлы с GitHub
echo -e "${BLUE}📥 Скачиваем console_function.sh...${NC}"
curl -sSL "https://raw.githubusercontent.com/helvegen1337/diagnostika/main/console_function.sh" -o "$INSTALL_DIR/console_function.sh"

echo -e "${BLUE}📥 Скачиваем diagnostika_v2.py...${NC}"
curl -sSL "https://raw.githubusercontent.com/helvegen1337/diagnostika/main/diagnostika_v2.py" -o "$INSTALL_DIR/diagnostika_v2.py"

# Проверяем, что файлы скачались успешно
if [ ! -f "$INSTALL_DIR/console_function.sh" ]; then
    echo -e "${RED}❌ Ошибка: Не удалось скачать console_function.sh${NC}"
    exit 1
fi

if [ ! -f "$INSTALL_DIR/diagnostika_v2.py" ]; then
    echo -e "${RED}❌ Ошибка: Не удалось скачать diagnostika_v2.py${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Все файлы успешно скачаны${NC}"

# Создаем основной скрипт
cat > "$INSTALL_DIR/diagnostika.sh" << 'EOF'
#!/bin/bash

# Diagnostika v2.0 - Основной скрипт
# Автоматически определяет ОС и загружает соответствующие команды

# Определяем ОС
OS_TYPE=""
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS_TYPE="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS_TYPE="macos"
elif [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "msys" ]]; then
    OS_TYPE="windows"
else
    OS_TYPE="linux"  # По умолчанию
fi

# Функция диагностики с разделением по ОС
diagnostika() {
    local category="$1"
    
    # Главное меню
    if [ -z "$category" ]; then
        echo "╔══════════════════════════════════════════════════════════════════════════════════════════════════════════╗"
        echo "║                                   Diagnostika v2.0 - Универсальная система                               ║"
        echo "╚══════════════════════════════════════════════════════════════════════════════════════════════════════════╝"
        echo "                         Доступные категории"
        echo "╭──────────────────────────────┬────────────┬────────────────╮"
        echo "│   🌐 Диагностика сети        │ 📁 Меню    │ 12 команд      │"
        echo "│   ⚙️ Системная информация    │ 📁 Меню    │ 15 команд      │"
        echo "│   💾 Анализ хранилища       │ 📁 Меню    │ 12 команд      │"
        echo "│   🔒 Проверка безопасности  │ 📁 Меню    │ 12 команд      │"
        echo "│   📊 Мониторинг производительности │ 📁 Меню │ 12 команд      │"
        echo "│   🐳 Статус Docker          │ 📁 Меню    │ 12 команд      │"
        echo "│   🗄️ Статус баз данных      │ 📁 Меню    │ 10 команд      │"
        echo "│   🌍 Веб-сервисы            │ 📁 Меню    │ 10 команд      │"
        echo "│   💿 Статус резервного копирования │ 📁 Меню │ 8 команд       │"
        echo "│   🔧 Системные службы       │ 📁 Меню    │ 10 команд      │"
        echo "│   📱 Процессы и процессы    │ 📁 Меню    │ 10 команд      │"
        echo "│   🌡️ Мониторинг системы     │ 📁 Меню    │ 8 команд       │"
        echo "╰──────────────────────────────┴────────────┴────────────────╯"
        echo ""
        echo "Использование: diagnostika <категория>"
        echo "Примеры:"
        echo "  diagnostika network    - Диагностика сети"
        echo "  diagnostika system     - Системная информация"
        echo "  diagnostika storage    - Анализ хранилища"
        echo "  diagnostika security   - Проверка безопасности"
        echo "  diagnostika performance - Мониторинг производительности"
        echo "  diagnostika docker     - Статус Docker"
        echo "  diagnostika database   - Статус баз данных"
        echo "  diagnostika web        - Веб-сервисы"
        echo "  diagnostika backup     - Статус резервного копирования"
        echo "  diagnostika services   - Системные службы"
        echo "  diagnostika processes  - Процессы и процессы"
        echo "  diagnostika monitoring - Мониторинг системы"
        return
    fi
    
    # Вызываем соответствующую функцию в зависимости от ОС
    case "$OS_TYPE" in
        "linux"|"macos")
            diagnostika_linux "$category"
            ;;
        "windows")
            diagnostika_windows "$category"
            ;;
        *)
            diagnostika_linux "$category"
            ;;
    esac
}

# Функция для Linux/macOS
diagnostika_linux() {
    local category="$1"
    
    case "$category" in
        network)
            echo "╔══════════════════════════════════════════════════════════════════════════════════════════════════════════╗"
            echo "║                                        ДИАГНОСТИКА СЕТИ (Linux)                                       ║"
            echo "╚══════════════════════════════════════════════════════════════════════════════════════════════════════════╝"
            echo "1. Сетевые интерфейсы"
            echo "2. Сетевые соединения"
            echo "3. Таблица маршрутизации"
            echo "4. Конфигурация DNS"
            echo "5. Статистика сети"
            echo "6. Тест пинга"
            echo "7. Трассировка маршрута"
            echo "8. Тест пропускной способности"
            echo "9. Сетевые порты"
            echo "10. Сетевые протоколы"
            echo "11. Сетевые устройства"
            echo "12. Сетевая статистика в реальном времени"
            echo ""
            read -p "Выберите команду (1-12): " choice
            case "$choice" in
                1) ip addr show ;;
                2) ss -tuln ;;
                3) ip route show ;;
                4) cat /etc/resolv.conf ;;
                5) ss -s ;;
                6) ping -c 3 8.8.8.8 ;;
                7) traceroute 8.8.8.8 ;;
                8) echo "Тест пропускной способности: iperf3 -c speedtest.server.com" ;;
                9) netstat -tuln ;;
                10) cat /etc/protocols | head -20 ;;
                11) lspci | grep -i network ;;
                12) watch -n 1 'ss -s' ;;
                *) echo "Неверный выбор" ;;
            esac
            ;;
        system)
            echo "╔══════════════════════════════════════════════════════════════════════════════════════════════════════════╗"
            echo "║                                     СИСТЕМНАЯ ИНФОРМАЦИЯ (Linux)                                       ║"
            echo "╚══════════════════════════════════════════════════════════════════════════════════════════════════════════╝"
            echo "1. Информация о системе"
            echo "2. Информация о процессоре"
            echo "3. Информация о памяти"
            echo "4. Использование дисков"
            echo "5. Загрузка системы"
            echo "6. Топ процессов"
            echo "7. Статус служб"
            echo "8. Системные журналы"
            echo "9. Версия ядра"
            echo "10. Информация о дистрибутиве"
            echo "11. Системные переменные"
            echo "12. Информация о загрузчике"
            echo "13. Системные ограничения"
            echo "14. Информация о времени"
            echo "15. Системные вызовы"
            echo ""
            read -p "Выберите команду (1-15): " choice
            case "$choice" in
                1) uname -a ;;
                2) lscpu ;;
                3) free -h ;;
                4) df -h ;;
                5) uptime ;;
                6) ps aux --sort=-%cpu | head -10 ;;
                7) systemctl list-units --type=service --state=running | head -10 ;;
                8) journalctl -n 20 --no-pager ;;
                9) uname -r ;;
                10) cat /etc/os-release ;;
                11) env | head -20 ;;
                12) cat /proc/cmdline ;;
                13) ulimit -a ;;
                14) date && uptime ;;
                15) cat /proc/version ;;
                *) echo "Неверный выбор" ;;
            esac
            ;;
        storage)
            echo "╔══════════════════════════════════════════════════════════════════════════════════════════════════════════╗"
            echo "║                                        АНАЛИЗ ХРАНИЛИЩА (Linux)                                        ║"
            echo "╚══════════════════════════════════════════════════════════════════════════════════════════════════════════╝"
            echo "1. Разделы дисков"
            echo "2. Использование дисков"
            echo "3. Использование inode"
            echo "4. Точки монтирования"
            echo "5. Ввод-вывод дисков"
            echo "6. Большие файлы"
            echo "7. Здоровье дисков"
            echo "8. Статус LVM"
            echo "9. RAID массивы"
            echo "10. Файловые системы"
            echo "11. Статистика дисков"
            echo "12. Мониторинг дисков в реальном времени"
            echo ""
            read -p "Выберите команду (1-12): " choice
            case "$choice" in
                1) lsblk ;;
                2) df -h ;;
                3) df -i ;;
                4) mount | column -t ;;
                5) iostat -x 1 3 ;;
                6) find / -type f -size +100M 2>/dev/null | head -10 ;;
                7) smartctl -a /dev/sda 2>/dev/null || echo 'Smartctl недоступен' ;;
                8) lvs 2>/dev/null || echo 'LVM недоступен' ;;
                9) cat /proc/mdstat 2>/dev/null || echo 'RAID недоступен' ;;
                10) df -T ;;
                11) iostat -d 1 3 ;;
                12) watch -n 1 'df -h' ;;
                *) echo "Неверный выбор" ;;
            esac
            ;;
        security)
            echo "╔══════════════════════════════════════════════════════════════════════════════════════════════════════════╗"
            echo "║                                     ПРОВЕРКА БЕЗОПАСНОСТИ (Linux)                                      ║"
            echo "╚══════════════════════════════════════════════════════════════════════════════════════════════════════════╝"
            echo "1. Открытые порты"
            echo "2. Службы прослушивания"
            echo "3. Пользовательские учетные записи"
            echo "4. Пользователи sudo"
            echo "5. Неудачные входы"
            echo "6. Конфигурация SSH"
            echo "7. Статус брандмауэра"
            echo "8. Статус SELinux"
            echo "9. Проверка целостности файлов"
            echo "10. Аудит системы"
            echo "11. Проверка прав доступа"
            echo "12. Мониторинг безопасности в реальном времени"
            echo ""
            read -p "Выберите команду (1-12): " choice
            case "$choice" in
                1) netstat -tuln ;;
                2) ss -tuln ;;
                3) cat /etc/passwd | grep -v nologin ;;
                4) grep -Po '^sudo.+:\K.*$' /etc/group | tr ',' '\n' ;;
                5) journalctl -u ssh | grep 'Failed password' | tail -10 ;;
                6) grep -E '^(PermitRootLogin|PasswordAuthentication|Port)' /etc/ssh/sshd_config ;;
                7) iptables -L -n 2>/dev/null || ufw status 2>/dev/null || echo 'Брандмауэр не обнаружен' ;;
                8) sestatus 2>/dev/null || echo 'SELinux недоступен' ;;
                9) find /etc -type f -exec md5sum {} \; 2>/dev/null | head -10 ;;
                10) ausearch -m avc 2>/dev/null || echo 'Аудит недоступен' ;;
                11) find /etc -perm -4000 -ls 2>/dev/null ;;
                12) watch -n 1 'ss -tuln' ;;
                *) echo "Неверный выбор" ;;
            esac
            ;;
        performance)
            echo "╔══════════════════════════════════════════════════════════════════════════════════════════════════════════╗"
            echo "║                                  МОНИТОРИНГ ПРОИЗВОДИТЕЛЬНОСТИ (Linux)                                 ║"
            echo "╚══════════════════════════════════════════════════════════════════════════════════════════════════════════╝"
            echo "1. Использование процессора"
            echo "2. Использование памяти"
            echo "3. Загрузка системы"
            echo "4. Топ процессов"
            echo "5. Ожидание ввода-вывода"
            echo "6. Использование сети"
            echo "7. Ввод-вывод дисков"
            echo "8. Системные ресурсы"
            echo "9. Кэш и буферы"
            echo "10. Сетевые соединения"
            echo "11. Системные вызовы"
            echo "12. Мониторинг в реальном времени"
            echo ""
            read -p "Выберите команду (1-12): " choice
            case "$choice" in
                1) top -bn1 | grep 'Cpu(s)' ;;
                2) free -h ;;
                3) uptime ;;
                4) ps aux --sort=-%cpu | head -10 ;;
                5) iostat -x 1 3 ;;
                6) ss -s ;;
                7) iotop -b -n 1 2>/dev/null || iostat -x 1 3 ;;
                8) vmstat 1 3 ;;
                9) cat /proc/meminfo | grep -E "(Cached|Buffers|Dirty)" ;;
                10) ss -tuln | wc -l ;;
                11) cat /proc/stat | head -5 ;;
                12) htop 2>/dev/null || top ;;
                *) echo "Неверный выбор" ;;
            esac
            ;;
        docker)
            echo "╔══════════════════════════════════════════════════════════════════════════════════════════════════════════╗"
            echo "║                                        СТАТУС DOCKER (Linux)                                           ║"
            echo "╚══════════════════════════════════════════════════════════════════════════════════════════════════════════╝"
            echo "1. Версия Docker"
            echo "2. Запущенные контейнеры"
            echo "3. Все контейнеры"
            echo "4. Образы Docker"
            echo "5. Информация о системе Docker"
            echo "6. Сети Docker"
            echo "7. Тома Docker"
            echo "8. Журналы Docker"
            echo "9. Статистика контейнеров"
            echo "10. Проверка здоровья контейнеров"
            echo "11. Использование ресурсов Docker"
            echo "12. Мониторинг Docker в реальном времени"
            echo ""
            read -p "Выберите команду (1-12): " choice
            case "$choice" in
                1) docker --version ;;
                2) docker ps ;;
                3) docker ps -a ;;
                4) docker images ;;
                5) docker system df ;;
                6) docker network ls ;;
                7) docker volume ls ;;
                8) docker logs --tail 20 $(docker ps -q | head -1) 2>/dev/null || echo 'Нет запущенных контейнеров' ;;
                9) docker stats --no-stream ;;
                10) docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Health}}" ;;
                11) docker system df -v ;;
                12) watch -n 1 'docker ps' ;;
                *) echo "Неверный выбор" ;;
            esac
            ;;
        database)
            echo "╔══════════════════════════════════════════════════════════════════════════════════════════════════════════╗"
            echo "║                                     СТАТУС БАЗ ДАННЫХ (Linux)                                          ║"
            echo "╚══════════════════════════════════════════════════════════════════════════════════════════════════════════╝"
            echo "1. Статус MySQL"
            echo "2. Статус PostgreSQL"
            echo "3. Статус Redis"
            echo "4. Статус MongoDB"
            echo "5. Соединения с базами данных"
            echo "6. Процессы баз данных"
            echo "7. Проверка портов БД"
            echo "8. Статистика БД"
            echo "9. Конфигурация БД"
            echo "10. Мониторинг БД в реальном времени"
            echo ""
            read -p "Выберите команду (1-10): " choice
            case "$choice" in
                1) systemctl status mysql 2>/dev/null || systemctl status mysqld 2>/dev/null || echo 'MySQL не найден' ;;
                2) systemctl status postgresql 2>/dev/null || echo 'PostgreSQL не найден' ;;
                3) systemctl status redis 2>/dev/null || echo 'Redis не найден' ;;
                4) systemctl status mongod 2>/dev/null || echo 'MongoDB не найден' ;;
                5) netstat -an | grep -E ':(3306|5432|6379|27017)' ;;
                6) ps aux | grep -E '(mysql|postgres|redis|mongo)' | grep -v grep ;;
                7) ss -tuln | grep -E ':(3306|5432|6379|27017)' ;;
                8) echo "Статистика БД недоступна без подключения" ;;
                9) find /etc -name "*.cnf" -o -name "*.conf" 2>/dev/null | grep -E "(mysql|postgres|redis|mongo)" | head -5 ;;
                10) watch -n 1 'ss -tuln | grep -E ":(3306|5432|6379|27017)"' ;;
                *) echo "Неверный выбор" ;;
            esac
            ;;
        web)
            echo "╔══════════════════════════════════════════════════════════════════════════════════════════════════════════╗"
            echo "║                                        ВЕБ-СЕРВИСЫ (Linux)                                             ║"
            echo "╚══════════════════════════════════════════════════════════════════════════════════════════════════════════╝"
            echo "1. Статус веб-сервера"
            echo "2. Конфигурация веб-сервера"
            echo "3. Журналы веб-сервера"
            echo "4. SSL-сертификаты"
            echo "5. Веб-порты"
            echo "6. Процессы веб-сервера"
            echo "7. Виртуальные хосты"
            echo "8. Статистика веб-сервера"
            echo "9. Проверка доступности"
            echo "10. Мониторинг веб-сервера в реальном времени"
            echo ""
            read -p "Выберите команду (1-10): " choice
            case "$choice" in
                1) systemctl status nginx 2>/dev/null || systemctl status apache2 2>/dev/null || echo 'Веб-сервер не найден' ;;
                2) nginx -t 2>/dev/null || apache2ctl -t 2>/dev/null || echo 'Тест конфигурации веб-сервера не удался' ;;
                3) tail -20 /var/log/nginx/access.log 2>/dev/null || tail -20 /var/log/apache2/access.log 2>/dev/null || echo 'Журналы веб-сервера не найдены' ;;
                4) find /etc/ssl -name '*.crt' -o -name '*.pem' 2>/dev/null | head -5 ;;
                5) netstat -tuln | grep -E ':(80|443|8080|8443)' ;;
                6) ps aux | grep -E '(nginx|apache|httpd)' | grep -v grep ;;
                7) ls /etc/nginx/sites-available/ 2>/dev/null || ls /etc/apache2/sites-available/ 2>/dev/null || echo 'Виртуальные хосты не найдены' ;;
                8) curl -s http://localhost/nginx_status 2>/dev/null || echo 'Статистика недоступна' ;;
                9) curl -I http://localhost 2>/dev/null || echo 'Веб-сервер недоступен' ;;
                10) watch -n 1 'ss -tuln | grep -E ":(80|443|8080|8443)"' ;;
                *) echo "Неверный выбор" ;;
            esac
            ;;
        backup)
            echo "╔══════════════════════════════════════════════════════════════════════════════════════════════════════════╗"
            echo "║                                   СТАТУС РЕЗЕРВНОГО КОПИРОВАНИЯ (Linux)                                 ║"
            echo "╚══════════════════════════════════════════════════════════════════════════════════════════════════════════╝"
            echo "1. Службы резервного копирования"
            echo "2. Задачи cron"
            echo "3. Системный cron"
            echo "4. Недавние резервные копии"
            echo "5. Использование дисков для резервного копирования"
            echo "6. Процессы резервного копирования"
            echo "7. Проверка целостности резервных копий"
            echo "8. Мониторинг резервного копирования"
            echo ""
            read -p "Выберите команду (1-8): " choice
            case "$choice" in
                1) systemctl list-units | grep -i backup ;;
                2) crontab -l 2>/dev/null || echo 'Нет задач cron для текущего пользователя' ;;
                3) ls -la /etc/cron.*/ 2>/dev/null || echo 'Нет системных каталогов cron' ;;
                4) find /var/backup /var/backups /backup /backups -type f -mtime -7 2>/dev/null | head -10 ;;
                5) df -h | grep -E '(backup|backups)' ;;
                6) ps aux | grep -i backup | grep -v grep ;;
                7) find /var/backup /var/backups /backup /backups -name "*.md5" -o -name "*.sha256" 2>/dev/null | head -5 ;;
                8) watch -n 5 'ps aux | grep -i backup | grep -v grep' ;;
                *) echo "Неверный выбор" ;;
            esac
            ;;
        services)
            echo "╔══════════════════════════════════════════════════════════════════════════════════════════════════════════╗"
            echo "║                                       СИСТЕМНЫЕ СЛУЖБЫ (Linux)                                          ║"
            echo "╚══════════════════════════════════════════════════════════════════════════════════════════════════════════╝"
            echo "1. Все запущенные службы"
            echo "2. Остановленные службы"
            echo "3. Службы с ошибками"
            echo "4. Службы по типам"
            echo "5. Зависимости служб"
            echo "6. Журналы служб"
            echo "7. Статус systemd"
            echo "8. Службы по приоритету"
            echo "9. Службы по пользователям"
            echo "10. Мониторинг служб в реальном времени"
            echo ""
            read -p "Выберите команду (1-10): " choice
            case "$choice" in
                1) systemctl list-units --type=service --state=running ;;
                2) systemctl list-units --type=service --state=inactive ;;
                3) systemctl list-units --type=service --state=failed ;;
                4) systemctl list-units --type=service --all | head -20 ;;
                5) systemctl list-dependencies multi-user.target ;;
                6) journalctl -u systemd --no-pager | tail -20 ;;
                7) systemctl status ;;
                8) systemctl list-units --type=service --state=running --no-pager | head -20 ;;
                9) systemctl list-units --type=service --state=running --no-pager | grep -E "(root|system)" ;;
                10) watch -n 1 'systemctl list-units --type=service --state=running | head -10' ;;
                *) echo "Неверный выбор" ;;
            esac
            ;;
        processes)
            echo "╔══════════════════════════════════════════════════════════════════════════════════════════════════════════╗"
            echo "║                                    ПРОЦЕССЫ И ПРОЦЕССЫ (Linux)                                         ║"
            echo "╚══════════════════════════════════════════════════════════════════════════════════════════════════════════╝"
            echo "1. Топ процессов по CPU"
            echo "2. Топ процессов по памяти"
            echo "3. Все процессы"
            echo "4. Процессы по пользователям"
            echo "5. Дерево процессов"
            echo "6. Системные процессы"
            echo "7. Процессы с высоким приоритетом"
            echo "8. Зомби процессы"
            echo "9. Процессы по группам"
            echo "10. Мониторинг процессов в реальном времени"
            echo ""
            read -p "Выберите команду (1-10): " choice
            case "$choice" in
                1) ps aux --sort=-%cpu | head -10 ;;
                2) ps aux --sort=-%mem | head -10 ;;
                3) ps aux | head -20 ;;
                4) ps aux | grep -E "^$(whoami)" | head -10 ;;
                5) pstree -p | head -20 ;;
                6) ps aux | grep -E "^root" | head -10 ;;
                7) ps -eo pid,ppid,cmd,ni | sort -k4 -n | head -10 ;;
                8) ps aux | grep -E "Z" ;;
                9) ps -eo pid,ppid,cmd,pgid | head -20 ;;
                10) htop 2>/dev/null || top ;;
                *) echo "Неверный выбор" ;;
            esac
            ;;
        monitoring)
            echo "╔══════════════════════════════════════════════════════════════════════════════════════════════════════════╗"
            echo "║                                     МОНИТОРИНГ СИСТЕМЫ (Linux)                                          ║"
            echo "╚══════════════════════════════════════════════════════════════════════════════════════════════════════════╝"
            echo "1. Общий статус системы"
            echo "2. Мониторинг CPU"
            echo "3. Мониторинг памяти"
            echo "4. Мониторинг дисков"
            echo "5. Мониторинг сети"
            echo "6. Мониторинг температуры"
            echo "7. Системные события"
            echo "8. Комплексный мониторинг"
            echo ""
            read -p "Выберите команду (1-8): " choice
            case "$choice" in
                1) echo "=== СТАТУС СИСТЕМЫ ===" && uptime && echo "=== ПРОЦЕССОР ===" && top -bn1 | grep 'Cpu(s)' && echo "=== ПАМЯТЬ ===" && free -h && echo "=== ДИСКИ ===" && df -h ;;
                2) watch -n 1 'top -bn1 | grep "Cpu(s)"' ;;
                3) watch -n 1 'free -h' ;;
                4) watch -n 1 'df -h' ;;
                5) watch -n 1 'ss -s' ;;
                6) sensors 2>/dev/null || echo 'Датчики температуры недоступны' ;;
                7) journalctl -f --no-pager ;;
                8) htop 2>/dev/null || top ;;
                *) echo "Неверный выбор" ;;
            esac
            ;;
        *)
            echo "Неизвестная категория: $category"
            echo "Доступные категории: network, system, storage, security, performance, docker, database, web, backup, services, processes, monitoring"
            ;;
    esac
}

# Функция для Windows (заглушка)
diagnostika_windows() {
    echo "Функция для Windows будет реализована в PowerShell версии"
    echo "Используйте: powershell -Command 'diag'"
}

# Создаем алиасы
alias diag='diagnostika'
alias help='diagnostika'
alias menu='diagnostika'

# Экспортируем функцию для подоболочек
export -f diagnostika
export -f diagnostika_linux
export -f diagnostika_windows

echo "✅ Diagnostika v2.0 загружена!"
echo "Доступные команды:"
echo "  diagnostika    - Показать главное меню"
echo "  diag           - То же самое (сокращение)"
echo "  help           - То же самое"
echo "  menu           - То же самое"
echo ""
echo "Быстрый доступ:"
echo "  diag network   - Диагностика сети (12 команд)"
echo "  diag system    - Системная информация (15 команд)"
echo "  diag storage   - Анализ хранилища (12 команд)"
echo "  diag security  - Проверка безопасности (12 команд)"
echo "  diag performance - Мониторинг производительности (12 команд)"
echo "  diag docker    - Статус Docker (12 команд)"
echo "  diag database  - Статус баз данных (10 команд)"
echo "  diag web       - Веб-сервисы (10 команд)"
echo "  diag backup    - Статус резервного копирования (8 команд)"
echo "  diag services  - Системные службы (10 команд)"
echo "  diag processes - Процессы и процессы (10 команд)"
echo "  diag monitoring - Мониторинг системы (8 команд)"
echo ""
echo "Использование: Просто введите 'diag' или 'help' для начала!"
EOF

# Делаем скрипт исполняемым
chmod +x "$INSTALL_DIR/diagnostika.sh"

# Добавляем в профиль оболочки
if ! grep -q "source.*diagnostika.sh" "$SHELL_RC"; then
    echo "" >> "$SHELL_RC"
    echo "# Diagnostika v2.0 - Автоматическая загрузка" >> "$SHELL_RC"
    echo "source \"$INSTALL_DIR/diagnostika.sh\"" >> "$SHELL_RC"
    echo -e "${GREEN}✅ Добавлено в ${SHELL_RC}${NC}"
else
    echo -e "${YELLOW}⚠️  Diagnostika уже установлена в ${SHELL_RC}${NC}"
fi

echo ""
echo -e "${GREEN}🎉 Установка завершена!${NC}"
echo ""
echo -e "${BLUE}📋 Что было сделано:${NC}"
echo -e "  ✅ Создана директория: ${INSTALL_DIR}"
echo -e "  ✅ Скопированы файлы"
echo -e "  ✅ Создан основной скрипт"
echo -e "  ✅ Добавлено в профиль: ${SHELL_RC}"
echo ""
echo -e "${BLUE}🚀 Использование:${NC}"
echo -e "  Перезапустите терминал или выполните:"
echo -e "  ${YELLOW}source ${SHELL_RC}${NC}"
echo ""
echo -e "${BLUE}🎮 Команды:${NC}"
echo -e "  ${YELLOW}diag${NC}           - Показать главное меню"
echo -e "  ${YELLOW}diag network${NC}   - Диагностика сети (12 команд)"
echo -e "  ${YELLOW}diag system${NC}    - Системная информация (15 команд)"
echo -e "  ${YELLOW}diag storage${NC}   - Анализ хранилища (12 команд)"
echo ""
echo -e "${GREEN}✨ Diagnostika v2.0 готова к использованию!${NC}" 