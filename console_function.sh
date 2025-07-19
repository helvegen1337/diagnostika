#!/bin/bash
# Diagnostika v2.0 - Универсальная Bash функция
# Скопируйте и вставьте этот блок в любую bash сессию

diagnostika() {
    local category="$1"
    
    # Главное меню
    if [ -z "$category" ]; then
        echo "╔══════════════════════════════════════════════════════════════════════════════════════════════════════════╗"
        echo "║                                   Diagnostika v2.0 - Bash Edition                                       ║"
        echo "╚══════════════════════════════════════════════════════════════════════════════════════════════════════════╝"
        echo "                         Доступные категории"
        echo "╭──────────────────────────────┬────────────┬────────────────╮"
        echo "│   🌐 Диагностика сети        │ 📁 Меню    │ 8 команд       │"
        echo "│   ⚙️ Системная информация    │ 📁 Меню    │ 9 команд       │"
        echo "│   💾 Анализ хранилища       │ 📁 Меню    │ 8 команд       │"
        echo "│   🔒 Проверка безопасности  │ 📁 Меню    │ 8 команд       │"
        echo "│   📊 Мониторинг производительности │ 📁 Меню │ 8 команд       │"
        echo "│   🐳 Статус Docker          │ 📁 Меню    │ 8 команд       │"
        echo "│   🗄️ Статус баз данных      │ 📁 Меню    │ 6 команд       │"
        echo "│   🌍 Веб-сервисы            │ 📁 Меню    │ 6 команд       │"
        echo "│   💿 Статус резервного копирования │ 📁 Меню │ 6 команд       │"
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
        return
    fi
    
    case "$category" in
        network)
            echo "╔══════════════════════════════════════════════════════════════════════════════════════════════════════════╗"
            echo "║                                        ДИАГНОСТИКА СЕТИ                                             ║"
            echo "╚══════════════════════════════════════════════════════════════════════════════════════════════════════════╝"
            echo "1. Сетевые интерфейсы"
            echo "2. Сетевые соединения"
            echo "3. Таблица маршрутизации"
            echo "4. Конфигурация DNS"
            echo "5. Статистика сети"
            echo "6. Тест пинга"
            echo "7. Трассировка маршрута"
            echo "8. Тест пропускной способности"
            echo ""
            read -p "Выберите команду (1-8): " choice
            case "$choice" in
                1) ip addr show ;;
                2) ss -tuln ;;
                3) ip route show ;;
                4) cat /etc/resolv.conf ;;
                5) ss -s ;;
                6) ping -c 3 8.8.8.8 ;;
                7) traceroute 8.8.8.8 ;;
                8) echo "Тест пропускной способности: iperf3 -c speedtest.server.com" ;;
                *) echo "Неверный выбор" ;;
            esac
            ;;
        system)
            echo "╔══════════════════════════════════════════════════════════════════════════════════════════════════════════╗"
            echo "║                                     СИСТЕМНАЯ ИНФОРМАЦИЯ                                             ║"
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
            echo ""
            read -p "Выберите команду (1-9): " choice
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
                *) echo "Неверный выбор" ;;
            esac
            ;;
        storage)
            echo "╔══════════════════════════════════════════════════════════════════════════════════════════════════════════╗"
            echo "║                                        АНАЛИЗ ХРАНИЛИЩА                                              ║"
            echo "╚══════════════════════════════════════════════════════════════════════════════════════════════════════════╝"
            echo "1. Разделы дисков"
            echo "2. Использование дисков"
            echo "3. Использование inode"
            echo "4. Точки монтирования"
            echo "5. Ввод-вывод дисков"
            echo "6. Большие файлы"
            echo "7. Здоровье дисков"
            echo "8. Статус LVM"
            echo ""
            read -p "Выберите команду (1-8): " choice
            case "$choice" in
                1) lsblk ;;
                2) df -h ;;
                3) df -i ;;
                4) mount | column -t ;;
                5) iostat -x 1 3 ;;
                6) find / -type f -size +100M 2>/dev/null | head -10 ;;
                7) smartctl -a /dev/sda 2>/dev/null || echo 'Smartctl недоступен' ;;
                8) lvs 2>/dev/null || echo 'LVM недоступен' ;;
                *) echo "Неверный выбор" ;;
            esac
            ;;
        security)
            echo "╔══════════════════════════════════════════════════════════════════════════════════════════════════════════╗"
            echo "║                                     ПРОВЕРКА БЕЗОПАСНОСТИ                                           ║"
            echo "╚══════════════════════════════════════════════════════════════════════════════════════════════════════════╝"
            echo "1. Открытые порты"
            echo "2. Службы прослушивания"
            echo "3. Пользовательские учетные записи"
            echo "4. Пользователи sudo"
            echo "5. Неудачные входы"
            echo "6. Конфигурация SSH"
            echo "7. Статус брандмауэра"
            echo "8. Статус SELinux"
            echo ""
            read -p "Выберите команду (1-8): " choice
            case "$choice" in
                1) netstat -tuln ;;
                2) ss -tuln ;;
                3) cat /etc/passwd | grep -v nologin ;;
                4) grep -Po '^sudo.+:\K.*$' /etc/group | tr ',' '\n' ;;
                5) journalctl -u ssh | grep 'Failed password' | tail -10 ;;
                6) grep -E '^(PermitRootLogin|PasswordAuthentication|Port)' /etc/ssh/sshd_config ;;
                7) iptables -L -n 2>/dev/null || ufw status 2>/dev/null || echo 'Брандмауэр не обнаружен' ;;
                8) sestatus 2>/dev/null || echo 'SELinux недоступен' ;;
                *) echo "Неверный выбор" ;;
            esac
            ;;
        performance)
            echo "╔══════════════════════════════════════════════════════════════════════════════════════════════════════════╗"
            echo "║                                  МОНИТОРИНГ ПРОИЗВОДИТЕЛЬНОСТИ                                       ║"
            echo "╚══════════════════════════════════════════════════════════════════════════════════════════════════════════╝"
            echo "1. Использование процессора"
            echo "2. Использование памяти"
            echo "3. Загрузка системы"
            echo "4. Топ процессов"
            echo "5. Ожидание ввода-вывода"
            echo "6. Использование сети"
            echo "7. Ввод-вывод дисков"
            echo "8. Системные ресурсы"
            echo ""
            read -p "Выберите команду (1-8): " choice
            case "$choice" in
                1) top -bn1 | grep 'Cpu(s)' ;;
                2) free -h ;;
                3) uptime ;;
                4) ps aux --sort=-%cpu | head -10 ;;
                5) iostat -x 1 3 ;;
                6) ss -s ;;
                7) iotop -b -n 1 2>/dev/null || iostat -x 1 3 ;;
                8) vmstat 1 3 ;;
                *) echo "Неверный выбор" ;;
            esac
            ;;
        docker)
            echo "╔══════════════════════════════════════════════════════════════════════════════════════════════════════════╗"
            echo "║                                        СТАТУС DOCKER                                                 ║"
            echo "╚══════════════════════════════════════════════════════════════════════════════════════════════════════════╝"
            echo "1. Версия Docker"
            echo "2. Запущенные контейнеры"
            echo "3. Все контейнеры"
            echo "4. Образы Docker"
            echo "5. Информация о системе Docker"
            echo "6. Сети Docker"
            echo "7. Тома Docker"
            echo "8. Журналы Docker"
            echo ""
            read -p "Выберите команду (1-8): " choice
            case "$choice" in
                1) docker --version ;;
                2) docker ps ;;
                3) docker ps -a ;;
                4) docker images ;;
                5) docker system df ;;
                6) docker network ls ;;
                7) docker volume ls ;;
                8) docker logs --tail 20 $(docker ps -q | head -1) 2>/dev/null || echo 'Нет запущенных контейнеров' ;;
                *) echo "Неверный выбор" ;;
            esac
            ;;
        database)
            echo "╔══════════════════════════════════════════════════════════════════════════════════════════════════════════╗"
            echo "║                                     СТАТУС БАЗ ДАННЫХ                                                ║"
            echo "╚══════════════════════════════════════════════════════════════════════════════════════════════════════════╝"
            echo "1. Статус MySQL"
            echo "2. Статус PostgreSQL"
            echo "3. Статус Redis"
            echo "4. Статус MongoDB"
            echo "5. Соединения с базами данных"
            echo "6. Процессы баз данных"
            echo ""
            read -p "Выберите команду (1-6): " choice
            case "$choice" in
                1) systemctl status mysql 2>/dev/null || systemctl status mysqld 2>/dev/null || echo 'MySQL не найден' ;;
                2) systemctl status postgresql 2>/dev/null || echo 'PostgreSQL не найден' ;;
                3) systemctl status redis 2>/dev/null || echo 'Redis не найден' ;;
                4) systemctl status mongod 2>/dev/null || echo 'MongoDB не найден' ;;
                5) netstat -an | grep :3306 || netstat -an | grep :5432 || echo 'Соединения с базами данных не найдены' ;;
                6) ps aux | grep -E '(mysql|postgres|redis|mongo)' | grep -v grep ;;
                *) echo "Неверный выбор" ;;
            esac
            ;;
        web)
            echo "╔══════════════════════════════════════════════════════════════════════════════════════════════════════════╗"
            echo "║                                        ВЕБ-СЕРВИСЫ                                                   ║"
            echo "╚══════════════════════════════════════════════════════════════════════════════════════════════════════════╝"
            echo "1. Статус веб-сервера"
            echo "2. Конфигурация веб-сервера"
            echo "3. Журналы веб-сервера"
            echo "4. SSL-сертификаты"
            echo "5. Веб-порты"
            echo "6. Процессы веб-сервера"
            echo ""
            read -p "Выберите команду (1-6): " choice
            case "$choice" in
                1) systemctl status nginx 2>/dev/null || systemctl status apache2 2>/dev/null || echo 'Веб-сервер не найден' ;;
                2) nginx -t 2>/dev/null || apache2ctl -t 2>/dev/null || echo 'Тест конфигурации веб-сервера не удался' ;;
                3) tail -20 /var/log/nginx/access.log 2>/dev/null || tail -20 /var/log/apache2/access.log 2>/dev/null || echo 'Журналы веб-сервера не найдены' ;;
                4) find /etc/ssl -name '*.crt' -o -name '*.pem' 2>/dev/null | head -5 ;;
                5) netstat -tuln | grep -E ':(80|443|8080|8443)' ;;
                6) ps aux | grep -E '(nginx|apache|httpd)' | grep -v grep ;;
                *) echo "Неверный выбор" ;;
            esac
            ;;
        backup)
            echo "╔══════════════════════════════════════════════════════════════════════════════════════════════════════════╗"
            echo "║                                   СТАТУС РЕЗЕРВНОГО КОПИРОВАНИЯ                                       ║"
            echo "╚══════════════════════════════════════════════════════════════════════════════════════════════════════════╝"
            echo "1. Службы резервного копирования"
            echo "2. Задачи cron"
            echo "3. Системный cron"
            echo "4. Недавние резервные копии"
            echo "5. Использование дисков для резервного копирования"
            echo "6. Процессы резервного копирования"
            echo ""
            read -p "Выберите команду (1-6): " choice
            case "$choice" in
                1) systemctl list-units | grep -i backup ;;
                2) crontab -l 2>/dev/null || echo 'Нет задач cron для текущего пользователя' ;;
                3) ls -la /etc/cron.*/ 2>/dev/null || echo 'Нет системных каталогов cron' ;;
                4) find /var/backup /var/backups /backup /backups -type f -mtime -7 2>/dev/null | head -10 ;;
                5) df -h | grep -E '(backup|backups)' ;;
                6) ps aux | grep -i backup | grep -v grep ;;
                *) echo "Неверный выбор" ;;
            esac
            ;;
        *)
            echo "Неизвестная категория: $category"
            echo "Доступные категории: network, system, storage, security, performance, docker, database, web, backup"
            ;;
    esac
}

# Создаем алиасы
alias diag='diagnostika'
alias help='diagnostika'
alias menu='diagnostika'

# Экспортируем функцию для подоболочек
export -f diagnostika

echo "✅ Diagnostika v2.0 Bash функция загружена!"
echo "Доступные команды:"
echo "  diagnostika    - Показать главное меню"
echo "  diag           - То же самое (сокращение)"
echo "  help           - То же самое"
echo "  menu           - То же самое"
echo ""
echo "Быстрый доступ:"
echo "  diag network   - Диагностика сети"
echo "  diag system    - Системная информация"
echo "  diag storage   - Анализ хранилища"
echo "  diag security  - Проверка безопасности"
echo "  diag performance - Мониторинг производительности"
echo ""
echo "Использование: Просто введите 'diag' или 'help' для начала!" 