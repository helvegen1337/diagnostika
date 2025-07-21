#!/bin/bash
# Diagnostika v2.0 - Универсальная Bash функция
# Скопируйте и вставьте этот блок в любую bash сессию

# Функция для отображения интерактивного меню
show_interactive_menu() {
    local category="$1"
    local title="$2"
    local commands=("${@:3}")
    
    while true; do
        clear
        echo "╔══════════════════════════════════════════════════════════════════════════════════════════════════════════╗"
        echo "║                                        $title                                                          ║"
        echo "╚══════════════════════════════════════════════════════════════════════════════════════════════════════════╝"
        
        # Отображаем команды
        for i in "${!commands[@]}"; do
            echo "$((i+1)). ${commands[i]}"
        done
        
        echo ""
        echo "0. Вернуться в главное меню"
        echo "q. Выйти из Diagnostika"
        echo ""
        
        read -p "Выберите команду: " choice
        
        case "$choice" in
            0) return 0 ;;
            q|Q) echo "До свидания!"; exit 0 ;;
            [1-9]|[1-9][0-9])
                local index=$((choice-1))
                if [ $index -lt ${#commands[@]} ]; then
                    echo ""
                    echo "🔧 Выполняю: ${commands[index]}"
                    echo "══════════════════════════════════════════════════════════════════════════════════════════════════════════"
                    
                    # Выполняем команду в зависимости от категории
                    execute_command "$category" "$choice"
                    
                    echo ""
                    echo "══════════════════════════════════════════════════════════════════════════════════════════════════════════"
                    echo "✅ Команда выполнена"
                    echo ""
                    read -p "Нажмите Enter для продолжения..."
                else
                    echo "❌ Неверный выбор"
                    sleep 2
                fi
                ;;
            *) 
                echo "❌ Неверный выбор"
                sleep 2
                ;;
        esac
    done
}

# Функция для выполнения команд
execute_command() {
    local category="$1"
    local choice="$2"
    
    case "$category" in
        network)
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
                10) docker system prune -f ;;
                11) docker info ;;
                12) watch -n 1 'docker ps' ;;
                *) echo "Неверный выбор" ;;
            esac
            ;;
        database)
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
            ;;
    esac
}

# Основная функция diagnostika с интерактивным меню
diagnostika() {
    local category="$1"
    
    # Главное меню
    if [ -z "$category" ]; then
        while true; do
            clear
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
            echo "0. Выйти из Diagnostika"
            echo ""
            
            read -p "Выберите категорию: " choice
            
            case "$choice" in
                0|q|Q) echo "До свидания!"; exit 0 ;;
                1|network) 
                    show_interactive_menu "network" "ДИАГНОСТИКА СЕТИ" \
                        "Сетевые интерфейсы" "Сетевые соединения" "Таблица маршрутизации" \
                        "Конфигурация DNS" "Статистика сети" "Тест пинга" "Трассировка маршрута" \
                        "Тест пропускной способности" "Сетевые порты" "Сетевые протоколы" \
                        "Сетевые устройства" "Сетевая статистика в реальном времени"
                    ;;
                2|system)
                    show_interactive_menu "system" "СИСТЕМНАЯ ИНФОРМАЦИЯ" \
                        "Информация о системе" "Информация о процессоре" "Информация о памяти" \
                        "Использование дисков" "Загрузка системы" "Топ процессов" "Статус служб" \
                        "Системные журналы" "Версия ядра" "Информация о дистрибутиве" \
                        "Системные переменные" "Информация о загрузчике" "Системные ограничения" \
                        "Информация о времени" "Системные вызовы"
                    ;;
                3|storage)
                    show_interactive_menu "storage" "АНАЛИЗ ХРАНИЛИЩА" \
                        "Разделы дисков" "Использование дисков" "Использование inode" \
                        "Точки монтирования" "Ввод-вывод дисков" "Большие файлы" \
                        "Здоровье дисков" "Статус LVM" "RAID массивы" "Файловые системы" \
                        "Статистика дисков" "Мониторинг дисков в реальном времени"
                    ;;
                4|security)
                    show_interactive_menu "security" "ПРОВЕРКА БЕЗОПАСНОСТИ" \
                        "Открытые порты" "Службы прослушивания" "Пользовательские учетные записи" \
                        "Пользователи sudo" "Неудачные входы" "Конфигурация SSH" \
                        "Статус брандмауэра" "Статус SELinux" "Проверка целостности файлов" \
                        "Аудит системы" "Проверка прав доступа" "Мониторинг безопасности в реальном времени"
                    ;;
                5|performance)
                    show_interactive_menu "performance" "МОНИТОРИНГ ПРОИЗВОДИТЕЛЬНОСТИ" \
                        "Использование процессора" "Использование памяти" "Загрузка системы" \
                        "Топ процессов" "Ожидание ввода-вывода" "Использование сети" \
                        "Ввод-вывод дисков" "Системные ресурсы" "Кэш и буферы" \
                        "Сетевые соединения" "Системные вызовы" "Мониторинг в реальном времени"
                    ;;
                6|docker)
                    show_interactive_menu "docker" "СТАТУС DOCKER" \
                        "Версия Docker" "Запущенные контейнеры" "Все контейнеры" \
                        "Образы Docker" "Информация о системе Docker" "Сети Docker" \
                        "Тома Docker" "Журналы Docker" "Статистика контейнеров" \
                        "Проверка здоровья контейнеров" "Использование ресурсов Docker" \
                        "Мониторинг Docker в реальном времени"
                    ;;
                7|database)
                    show_interactive_menu "database" "СТАТУС БАЗ ДАННЫХ" \
                        "Статус MySQL" "Статус PostgreSQL" "Статус Redis" "Статус MongoDB" \
                        "Соединения с базами данных" "Процессы баз данных" "Проверка портов БД" \
                        "Статистика БД" "Конфигурация БД" "Мониторинг БД в реальном времени"
                    ;;
                8|web)
                    show_interactive_menu "web" "ВЕБ-СЕРВИСЫ" \
                        "Статус веб-сервера" "Конфигурация веб-сервера" "Журналы веб-сервера" \
                        "SSL-сертификаты" "Веб-порты" "Процессы веб-сервера" \
                        "Виртуальные хосты" "Статистика веб-сервера" "Проверка доступности" \
                        "Мониторинг веб-сервера в реальном времени"
                    ;;
                9|backup)
                    show_interactive_menu "backup" "СТАТУС РЕЗЕРВНОГО КОПИРОВАНИЯ" \
                        "Службы резервного копирования" "Задачи cron" "Системный cron" \
                        "Недавние резервные копии" "Использование дисков для резервного копирования" \
                        "Процессы резервного копирования" "Проверка целостности резервных копий" \
                        "Мониторинг резервного копирования"
                    ;;
                10|services)
                    show_interactive_menu "services" "СИСТЕМНЫЕ СЛУЖБЫ" \
                        "Все запущенные службы" "Остановленные службы" "Службы с ошибками" \
                        "Службы по типам" "Зависимости служб" "Журналы служб" \
                        "Статус systemd" "Службы по приоритету" "Службы по пользователям" \
                        "Мониторинг служб в реальном времени"
                    ;;
                11|processes)
                    show_interactive_menu "processes" "ПРОЦЕССЫ И ПРОЦЕССЫ" \
                        "Топ процессов по CPU" "Топ процессов по памяти" "Все процессы" \
                        "Процессы по пользователям" "Дерево процессов" "Системные процессы" \
                        "Процессы с высоким приоритетом" "Зомби процессы" "Процессы по группам" \
                        "Мониторинг процессов в реальном времени"
                    ;;
                12|monitoring)
                    show_interactive_menu "monitoring" "МОНИТОРИНГ СИСТЕМЫ" \
                        "Общий статус системы" "Мониторинг CPU" "Мониторинг памяти" \
                        "Мониторинг дисков" "Мониторинг сети" "Мониторинг температуры" \
                        "Системные события" "Комплексный мониторинг"
                    ;;
                *) 
                    echo "❌ Неверный выбор"
                    sleep 2
                    ;;
            esac
        done
    else
        # Прямой вызов категории (для обратной совместимости)
        case "$category" in
            network) 
                show_interactive_menu "network" "ДИАГНОСТИКА СЕТИ" \
                    "Сетевые интерфейсы" "Сетевые соединения" "Таблица маршрутизации" \
                    "Конфигурация DNS" "Статистика сети" "Тест пинга" "Трассировка маршрута" \
                    "Тест пропускной способности" "Сетевые порты" "Сетевые протоколы" \
                    "Сетевые устройства" "Сетевая статистика в реальном времени"
                ;;
            system)
                show_interactive_menu "system" "СИСТЕМНАЯ ИНФОРМАЦИЯ" \
                    "Информация о системе" "Информация о процессоре" "Информация о памяти" \
                    "Использование дисков" "Загрузка системы" "Топ процессов" "Статус служб" \
                    "Системные журналы" "Версия ядра" "Информация о дистрибутиве" \
                    "Системные переменные" "Информация о загрузчике" "Системные ограничения" \
                    "Информация о времени" "Системные вызовы"
                ;;
            storage)
                show_interactive_menu "storage" "АНАЛИЗ ХРАНИЛИЩА" \
                    "Разделы дисков" "Использование дисков" "Использование inode" \
                    "Точки монтирования" "Ввод-вывод дисков" "Большие файлы" \
                    "Здоровье дисков" "Статус LVM" "RAID массивы" "Файловые системы" \
                    "Статистика дисков" "Мониторинг дисков в реальном времени"
                ;;
            security)
                show_interactive_menu "security" "ПРОВЕРКА БЕЗОПАСНОСТИ" \
                    "Открытые порты" "Службы прослушивания" "Пользовательские учетные записи" \
                    "Пользователи sudo" "Неудачные входы" "Конфигурация SSH" \
                    "Статус брандмауэра" "Статус SELinux" "Проверка целостности файлов" \
                    "Аудит системы" "Проверка прав доступа" "Мониторинг безопасности в реальном времени"
                ;;
            performance)
                show_interactive_menu "performance" "МОНИТОРИНГ ПРОИЗВОДИТЕЛЬНОСТИ" \
                    "Использование процессора" "Использование памяти" "Загрузка системы" \
                    "Топ процессов" "Ожидание ввода-вывода" "Использование сети" \
                    "Ввод-вывод дисков" "Системные ресурсы" "Кэш и буферы" \
                    "Сетевые соединения" "Системные вызовы" "Мониторинг в реальном времени"
                ;;
            docker)
                show_interactive_menu "docker" "СТАТУС DOCKER" \
                    "Версия Docker" "Запущенные контейнеры" "Все контейнеры" \
                    "Образы Docker" "Информация о системе Docker" "Сети Docker" \
                    "Тома Docker" "Журналы Docker" "Статистика контейнеров" \
                    "Проверка здоровья контейнеров" "Использование ресурсов Docker" \
                    "Мониторинг Docker в реальном времени"
                ;;
            database)
                show_interactive_menu "database" "СТАТУС БАЗ ДАННЫХ" \
                    "Статус MySQL" "Статус PostgreSQL" "Статус Redis" "Статус MongoDB" \
                    "Соединения с базами данных" "Процессы баз данных" "Проверка портов БД" \
                    "Статистика БД" "Конфигурация БД" "Мониторинг БД в реальном времени"
                ;;
            web)
                show_interactive_menu "web" "ВЕБ-СЕРВИСЫ" \
                    "Статус веб-сервера" "Конфигурация веб-сервера" "Журналы веб-сервера" \
                    "SSL-сертификаты" "Веб-порты" "Процессы веб-сервера" \
                    "Виртуальные хосты" "Статистика веб-сервера" "Проверка доступности" \
                    "Мониторинг веб-сервера в реальном времени"
                ;;
            backup)
                show_interactive_menu "backup" "СТАТУС РЕЗЕРВНОГО КОПИРОВАНИЯ" \
                    "Службы резервного копирования" "Задачи cron" "Системный cron" \
                    "Недавние резервные копии" "Использование дисков для резервного копирования" \
                    "Процессы резервного копирования" "Проверка целостности резервных копий" \
                    "Мониторинг резервного копирования"
                ;;
            services)
                show_interactive_menu "services" "СИСТЕМНЫЕ СЛУЖБЫ" \
                    "Все запущенные службы" "Остановленные службы" "Службы с ошибками" \
                    "Службы по типам" "Зависимости служб" "Журналы служб" \
                    "Статус systemd" "Службы по приоритету" "Службы по пользователям" \
                    "Мониторинг служб в реальном времени"
                ;;
            processes)
                show_interactive_menu "processes" "ПРОЦЕССЫ И ПРОЦЕССЫ" \
                    "Топ процессов по CPU" "Топ процессов по памяти" "Все процессы" \
                    "Процессы по пользователям" "Дерево процессов" "Системные процессы" \
                    "Процессы с высоким приоритетом" "Зомби процессы" "Процессы по группам" \
                    "Мониторинг процессов в реальном времени"
                ;;
            monitoring)
                show_interactive_menu "monitoring" "МОНИТОРИНГ СИСТЕМЫ" \
                    "Общий статус системы" "Мониторинг CPU" "Мониторинг памяти" \
                    "Мониторинг дисков" "Мониторинг сети" "Мониторинг температуры" \
                    "Системные события" "Комплексный мониторинг"
                ;;
            *)
                echo "Неизвестная категория: $category"
                echo "Доступные категории: network, system, storage, security, performance, docker, database, web, backup, services, processes, monitoring"
                ;;
        esac
    fi
}

# Создаем алиасы
alias diag='diagnostika'
alias help='diagnostika'
alias menu='diagnostika'

# Экспортируем функцию для подоболочек
export -f diagnostika

 