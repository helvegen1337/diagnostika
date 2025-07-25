# Чек-Лист РМК - Система диагностики кассовых систем

## 📋 Описание

Чек-Лист РМК - это специализированная система диагностики для проверки работоспособности кассовых систем на базе Linux. Система выполняет комплексные проверки сетевого подключения, конфигурации, базы данных и оборудования.

## 🚀 Возможности

### 🔍 Основные проверки:
1. **Проверка доступности портов кассы** - SSH подключение и проверка портов (7795, 5900, 80, 28085, 22)
2. **Проверка доступности портов сервера** - с кассы к серверу (8080, 8084, 10001, 8140)
3. **Проверка доступности репозиториев** - Artix, Docker, Ubuntu
4. **Проверка настройки соотнесения налогов** - конфигурация налогов
5. **Проверка настройки соотнесения типов оплат** - конфигурация оплат
6. **Проверка Puppet** - доступность, конфигурация, выполнение
7. **Проверка плагина маркировки** - настройки маркировки товаров
8. **Проверка ЛМ ЧЗ** - установка, готовность, инициализация
9. **Проверка EGAIS** - конфигурация, ИП с портом 8080
10. **Проверка настройки оперативных продаж** - БД, таблицы macros и события
11. **Проверка загрузки справочников** - загрузка данных
12. **Проверка выгрузки продаж** - выгрузка данных
13. **Проверка справочника ролей и действий** - права доступа
14. **Проверка целостности Меню** - структура меню
15. **Проверка оборудования** - сканер, ФР, пинпад, весы, ДП
16. **Проверки через XDTool** - имитация действий кассира (8 пунктов)

### 📊 Форматы отчетов:
- **≤3 проверки** → вывод в консоль
- **>3 проверки** → файл-отчет
- **Все проверки** → файл-отчет

## 🛠️ Установка

### Требования:
- Python 3.7+
- Linux система
- Доступ к SSH на кассе
- Доступ к MySQL базе данных

### Установка зависимостей:
```bash
pip3 install -r requirements.txt
```

## 🎯 Использование

### Запуск:
```bash
python3 rmk_checklist.py
```

### Интерактивное меню:
```
ЧЕК-ЛИСТ РМК - Система диагностики
1.  Проверка доступности портов кассы
2.  Проверка доступности портов сервера
3.  Проверка доступности репозиториев
4.  Проверка настройки соотнесения налогов
5.  Проверка настройки соотнесения типов оплат
6.  Проверка Puppet
7.  Проверка плагина маркировки
8.  Проверка ЛМ ЧЗ
9.  Проверка EGAIS
10. Проверка настройки оперативных продаж
11. Проверка загрузки справочников
12. Проверка выгрузки продаж
13. Проверка справочника ролей и действий
14. Проверка целостности Меню
15. Проверка оборудования
16. Проверки через XDTool (8 пунктов)
17. Запустить все проверки
18. Выбрать несколько проверок
0.  Выход
```

## ⚙️ Конфигурация

### Настройка подключения:
При первом запуске система запросит:
- **IP адрес кассы** - для SSH подключения
- **Логин** - пользователь на кассе
- **Пароль** - пароль пользователя
- **IP адрес сервера** - для проверки портов

### База данных:
По умолчанию используется:
- **Host:** localhost
- **Port:** 3306
- **User:** netroot
- **Password:** netroot
- **Database:** cashdb

### Стандартные пути:
- `/opt/linuxcash/cash/conf/ncash.ini` - основная конфигурация
- `/opt/linuxcash/cash/conf/plugins/egais_plugins.xml` - EGAIS плагин
- `/opt/linuxcash/cash/conf/puppet/markedgoods.ini` - маркировка

## 📁 Структура проекта

```
diagnostika_rmk/
├── rmk_checklist.py          # Главный скрипт
├── requirements.txt          # Зависимости Python
├── README_RMK.md            # Документация
├── config/
│   └── rmk_config.json      # Конфигурация (опционально)
└── reports/                 # Папка для отчетов
    └── rmk_report_*.txt     # Генерируемые отчеты
```

## 🔧 Технические детали

### Сетевые проверки:
- **SSH подключение** через библиотеку Paramiko
- **Проверка портов** через netcat (nc)
- **HTTP запросы** через requests
- **TCP соединения** через socket

### База данных:
- **MySQL** через mysql-connector-python
- **Проверка таблиц** macros и события
- **Поиск параметров** "почековая выгрузка"

### Puppet проверки:
- **Ping puppet** - проверка доступности
- **/etc/hosts** - проверка конфигурации
- **puppet agent --debug** - выполнение и анализ

### ЛМ ЧЗ проверки:
- **dpkg -l | grep regime** - проверка установки
- **Поиск 'ready' в логах** - проверка готовности
- **API запрос инициализации** - curl запрос с токеном

## 📝 Примеры использования

### Запуск одной проверки:
```bash
python3 rmk_checklist.py
# Выберите: 6 (Проверка Puppet)
```

### Запуск нескольких проверок:
```bash
python3 rmk_checklist.py
# Выберите: 18 (Выбрать несколько проверок)
# Введите: 1,3,6,8
```

### Полная диагностика:
```bash
python3 rmk_checklist.py
# Выберите: 17 (Запустить все проверки)
```

## 🐛 Устранение неполадок

### Ошибки подключения SSH:
- Проверьте IP адрес кассы
- Убедитесь в правильности логина/пароля
- Проверьте доступность SSH порта (22)

### Ошибки подключения к БД:
- Проверьте параметры подключения MySQL
- Убедитесь в запуске MySQL сервиса
- Проверьте права доступа пользователя

### Ошибки проверки портов:
- Проверьте доступность сетевого подключения
- Убедитесь в правильности IP адресов
- Проверьте настройки файрвола

## 📞 Поддержка

При возникновении проблем:
1. Проверьте логи выполнения
2. Убедитесь в корректности конфигурации
3. Проверьте доступность всех сервисов
4. Обратитесь к документации по РМК

## 🔄 Обновления

Система поддерживает обновления через Git:
```bash
git pull origin main
pip3 install -r requirements.txt --upgrade
```

---

**Версия:** 1.0.0  
**Дата:** 2025-07-20  
**Автор:** Diagnostika Team 