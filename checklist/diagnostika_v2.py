#!/usr/bin/env python3
"""
Linux Server Diagnostics TUI Tool v2.0
Упрощенная версия без модульной системы
"""

import os
import sys
import subprocess
import pyperclip
from typing import Dict, Any, List
from rich.console import Console
from rich.panel import Panel
from rich.table import Table
from rich.prompt import Prompt, Confirm
from rich.text import Text
from rich.layout import Layout
from rich.live import Live
from rich.align import Align
from rich import box
from rich.progress import Progress, SpinnerColumn, TextColumn
from rich.console import Group

# Инициализация Rich консоли
console = Console()

# Конфигурация приложения
CONFIG = {
    "title": "Диагностика Linux Серверов v2.0",
    "version": "2.0",
    "author": "Упрощенная система диагностики",
    "colors": {
        "primary": "cyan",
        "secondary": "yellow", 
        "success": "green",
        "error": "red",
        "warning": "yellow",
        "info": "blue",
        "module": "magenta"
    }
}

# Встроенные команды диагностики
DIAGNOSTIC_COMMANDS = {
    "🌐 Диагностика сети": {
        "Сетевые интерфейсы": "ip addr show",
        "Сетевые соединения": "ss -tuln",
        "Таблица маршрутизации": "ip route show",
        "Конфигурация DNS": "cat /etc/resolv.conf",
        "Статистика сети": "ss -s",
        "Тест пинга": "ping -c 3 8.8.8.8",
        "Трассировка маршрута": "traceroute 8.8.8.8",
        "Тест пропускной способности": "echo 'Тест пропускной способности: iperf3 -c speedtest.server.com'"
    },
    "⚙️ Системная информация": {
        "Информация о системе": "uname -a",
        "Информация о процессоре": "lscpu",
        "Информация о памяти": "free -h",
        "Использование дисков": "df -h",
        "Загрузка системы": "uptime",
        "Топ процессов": "ps aux --sort=-%cpu | head -10",
        "Статус служб": "systemctl list-units --type=service --state=running | head -10",
        "Системные журналы": "journalctl -n 20 --no-pager",
        "Версия ядра": "uname -r"
    },
    "💾 Анализ хранилища": {
        "Разделы дисков": "lsblk",
        "Использование дисков": "df -h",
        "Использование inode": "df -i",
        "Точки монтирования": "mount | column -t",
        "Ввод-вывод дисков": "iostat -x 1 3",
        "Большие файлы": "find / -type f -size +100M 2>/dev/null | head -10",
        "Здоровье дисков": "smartctl -a /dev/sda 2>/dev/null || echo 'Smartctl недоступен'",
        "Статус LVM": "lvs 2>/dev/null || echo 'LVM недоступен'"
    },
    "🔒 Проверка безопасности": {
        "Открытые порты": "netstat -tuln",
        "Службы прослушивания": "ss -tuln",
        "Пользовательские учетные записи": "cat /etc/passwd | grep -v nologin",
        "Пользователи sudo": "grep -Po '^sudo.+:\K.*$' /etc/group | tr ',' '\n'",
        "Неудачные входы": "journalctl -u ssh | grep 'Failed password' | tail -10",
        "Конфигурация SSH": "grep -E '^(PermitRootLogin|PasswordAuthentication|Port)' /etc/ssh/sshd_config",
        "Статус брандмауэра": "iptables -L -n 2>/dev/null || ufw status 2>/dev/null || echo 'Брандмауэр не обнаружен'",
        "Статус SELinux": "sestatus 2>/dev/null || echo 'SELinux недоступен'"
    },
    "📊 Мониторинг производительности": {
        "Использование процессора": "top -bn1 | grep 'Cpu(s)'",
        "Использование памяти": "free -h",
        "Загрузка системы": "uptime",
        "Топ процессов": "ps aux --sort=-%cpu | head -10",
        "Ожидание ввода-вывода": "iostat -x 1 3",
        "Использование сети": "ss -s",
        "Ввод-вывод дисков": "iotop -b -n 1 2>/dev/null || iostat -x 1 3",
        "Системные ресурсы": "vmstat 1 3"
    },
    "🐳 Статус Docker": {
        "Версия Docker": "docker --version",
        "Запущенные контейнеры": "docker ps",
        "Все контейнеры": "docker ps -a",
        "Образы Docker": "docker images",
        "Информация о системе Docker": "docker system df",
        "Сети Docker": "docker network ls",
        "Тома Docker": "docker volume ls",
        "Журналы Docker": "docker logs --tail 20 $(docker ps -q | head -1) 2>/dev/null || echo 'Нет запущенных контейнеров'"
    },
    "🗄️ Статус баз данных": {
        "Статус MySQL": "systemctl status mysql 2>/dev/null || systemctl status mysqld 2>/dev/null || echo 'MySQL не установлен'",
        "Статус PostgreSQL": "systemctl status postgresql 2>/dev/null || echo 'PostgreSQL не установлен'",
        "Статус MongoDB": "systemctl status mongod 2>/dev/null || echo 'MongoDB не установлен'",
        "Статус Redis": "systemctl status redis 2>/dev/null || echo 'Redis не установлен'",
        "Статус Elasticsearch": "systemctl status elasticsearch 2>/dev/null || echo 'Elasticsearch не установлен'",
        "Статус InfluxDB": "systemctl status influxdb 2>/dev/null || echo 'InfluxDB не установлен'"
    },
    "🌍 Веб-сервисы": {
        "Статус Apache": "systemctl status apache2 2>/dev/null || systemctl status httpd 2>/dev/null || echo 'Apache не установлен'",
        "Статус Nginx": "systemctl status nginx 2>/dev/null || echo 'Nginx не установлен'",
        "Статус PHP-FPM": "systemctl status php-fpm 2>/dev/null || systemctl status php8.1-fpm 2>/dev/null || echo 'PHP-FPM не установлен'",
        "Статус Node.js": "node --version 2>/dev/null || echo 'Node.js не установлен'",
        "Статус PM2": "pm2 status 2>/dev/null || echo 'PM2 не установлен'",
        "Статус Supervisor": "supervisorctl status 2>/dev/null || echo 'Supervisor не установлен'"
    },
    "💿 Статус резервного копирования": {
        "Статус cron": "systemctl status cron 2>/dev/null || systemctl status crond 2>/dev/null || echo 'Cron не установлен'",
        "Задачи cron": "crontab -l 2>/dev/null || echo 'Нет задач cron'",
        "Статус rsync": "which rsync && echo 'rsync доступен' || echo 'rsync не установлен'",
        "Статус tar": "which tar && echo 'tar доступен' || echo 'tar не установлен'",
        "Статус dd": "which dd && echo 'dd доступен' || echo 'dd не установлен'",
        "Статус borg": "which borg && echo 'borg доступен' || echo 'borg не установлен'"
    }
}


class DiagnosticsTUIv2:
    """Упрощенная версия TUI без модульной архитектуры"""
    
    def __init__(self):
        self.console = console
        self.current_menu = DIAGNOSTIC_COMMANDS
        self.menu_stack = []
        self.selected_index = 0
        self.command_history = []
        
    def show_header(self):
        """Отображает заголовок приложения"""
        title = f" {CONFIG['title']} v{CONFIG['version']} "
        subtitle = f" Категорий: {len(self.current_menu)} "
        
        header = Panel(
            Align.center(Group(
                Text(title, style=f"bold {CONFIG['colors']['primary']}"),
                Text(subtitle, style=f"dim {CONFIG['colors']['info']}")
            )),
            style=f"bold {CONFIG['colors']['primary']}",
            box=box.DOUBLE
        )
        self.console.print(header)
        
    def show_menu(self, menu: Dict[str, Any], title: str = "Главное меню"):
        """Отображает интерактивное меню"""
        while True:
            self.console.clear()
            self.show_header()
            
            # Создаем таблицу меню
            table = Table(
                title=f" {title} ",
                show_header=False,
                box=box.ROUNDED,
                style=f"bold {CONFIG['colors']['primary']}"
            )
            
            table.add_column("Элемент", style="white")
            table.add_column("Тип", style="dim")
            table.add_column("Описание", style="dim")
            
            menu_items = list(menu.items())
            
            for i, (key, value) in enumerate(menu_items):
                if isinstance(value, dict):
                    item_type = "📁 Подменю"
                    description = f"{len(value)} команд"
                else:
                    item_type = "▶ Команда"
                    description = "Выполнить команду"
                
                style = f"bold {CONFIG['colors']['secondary']}" if i == self.selected_index else "white"
                table.add_row(f"  {key}", item_type, description, style=style)
            
            self.console.print(table)
            
            # Справка по навигации
            help_text = Text(
                "Навигация: W/S или ↑/↓ - Выбор | Enter - Выполнить | Q - Выход | H - История",
                style=f"dim {CONFIG['colors']['info']}"
            )
            self.console.print(help_text)
            
            # Обработка ввода пользователя
            try:
                key = self.console.input("").lower()
                
                if key == 'q':
                    return
                elif key == 'h':
                    self.show_command_history()
                    continue
                elif key in ['w', 'k', '8']:  # Вверх
                    self.selected_index = max(0, self.selected_index - 1)
                elif key in ['s', 'j', '2']:  # Вниз
                    self.selected_index = min(len(menu_items) - 1, self.selected_index + 1)
                elif key in ['', 'enter', ' ']:  # Enter или пробел
                    selected_key, selected_value = menu_items[self.selected_index]
                    
                    if isinstance(selected_value, dict):
                        # Подменю
                        self.menu_stack.append((menu, title, self.selected_index))
                        self.current_menu = selected_value
                        self.selected_index = 0
                        return self.show_menu(selected_value, selected_key)
                    else:
                        # Команда
                        self.execute_command(selected_value, selected_key)
                        self.selected_index = 0
                        
            except KeyboardInterrupt:
                return
                
    def execute_command(self, command: str, description: str):
        """Выполняет выбранную команду"""
        self.console.clear()
        self.show_header()
        
        # Добавляем в историю
        self.command_history.append({
            "command": command,
            "description": description,
            "timestamp": "now"  # В реальном приложении добавить datetime
        })
        
        # Показываем информацию о команде
        info_panel = Panel(
            f"[bold]Команда:[/bold] {description}\n\n"
            f"[bold]Команда для выполнения:[/bold]\n"
            f"[{CONFIG['colors']['secondary']}]{command}[/{CONFIG['colors']['secondary']}]",
            title="Выполнение команды",
            style=f"bold {CONFIG['colors']['info']}"
        )
        self.console.print(info_panel)
        
        # Копируем в буфер обмена
        try:
            pyperclip.copy(command)
            self.console.print(f"[{CONFIG['colors']['success']}]✓ Команда скопирована в буфер обмена[/{CONFIG['colors']['success']}]")
        except Exception as e:
            self.console.print(f"[{CONFIG['colors']['error']}]✗ Не удалось скопировать в буфер обмена: {e}[/{CONFIG['colors']['error']}]")
        
        # Опции
        options_table = Table(title="Опции", show_header=False, box=box.ROUNDED)
        options_table.add_column("Опция", style="white")
        options_table.add_column("Описание", style="dim")
        
        options_table.add_row("1", "Выполнить локально (если поддерживается)")
        options_table.add_row("2", "Скопировать в буфер обмена снова")
        options_table.add_row("3", "Вернуться в меню")
        options_table.add_row("Q", "Выход")
        
        self.console.print(options_table)
        
        # Обработка опций
        while True:
            choice = self.console.input("Выберите опцию: ").lower()
            
            if choice == '1':
                self._execute_command_locally(command)
                break
            elif choice == '2':
                try:
                    pyperclip.copy(command)
                    self.console.print(f"[{CONFIG['colors']['success']}]✓ Команда скопирована в буфер обмена снова[/{CONFIG['colors']['success']}]")
                except Exception as e:
                    self.console.print(f"[{CONFIG['colors']['error']}]✗ Не удалось скопировать в буфер обмена: {e}[/{CONFIG['colors']['error']}]")
            elif choice == '3':
                return
            elif choice == 'q':
                sys.exit(0)
    
    def _execute_command_locally(self, command: str):
        """Выполняет команду локально"""
        self.console.print(f"[{CONFIG['colors']['warning']}]Выполняю команду локально...[/{CONFIG['colors']['warning']}]")
        
        with Progress(
            SpinnerColumn(),
            TextColumn("[progress.description]{task.description}"),
            console=self.console
        ) as progress:
            task = progress.add_task("Выполнение команды...", total=None)
            
            try:
                result = subprocess.run(
                    command, 
                    shell=True, 
                    capture_output=True, 
                    text=True, 
                    timeout=30
                )
                
                progress.update(task, completed=True)
                
                if result.returncode == 0:
                    self.console.print(f"[{CONFIG['colors']['success']}]Команда выполнена успешно:[/{CONFIG['colors']['success']}]")
                    self.console.print(result.stdout)
                else:
                    self.console.print(f"[{CONFIG['colors']['error']}]Команда завершилась с ошибкой:[/{CONFIG['colors']['error']}]")
                    self.console.print(result.stderr)
                    
            except subprocess.TimeoutExpired:
                self.console.print(f"[{CONFIG['colors']['error']}]Команда превысила время ожидания[/{CONFIG['colors']['error']}]")
            except Exception as e:
                self.console.print(f"[{CONFIG['colors']['error']}]Ошибка выполнения: {e}[/{CONFIG['colors']['error']}]")
        
        self.console.input("Нажмите Enter для продолжения...")
    
    def show_command_history(self):
        """Показывает историю выполненных команд"""
        self.console.clear()
        self.show_header()
        
        if not self.command_history:
            self.console.print("[dim]История команд пуста[/dim]")
            self.console.input("Нажмите Enter для продолжения...")
            return
        
        table = Table(
            title=" История команд ",
            show_header=True,
            box=box.ROUNDED,
            style=f"bold {CONFIG['colors']['primary']}"
        )
        
        table.add_column("№", style="white")
        table.add_column("Описание", style="white")
        table.add_column("Команда", style="dim")
        
        for i, item in enumerate(self.command_history[-10:], 1):  # Показываем последние 10
            table.add_row(
                str(i),
                item["description"],
                item["command"][:50] + "..." if len(item["command"]) > 50 else item["command"]
            )
        
        self.console.print(table)
        self.console.input("Нажмите Enter для продолжения...")
    
    def run(self):
        """Запускает TUI приложение"""
        try:
            self.show_menu(self.current_menu, "Главное меню")
            
        except KeyboardInterrupt:
            self.console.print(f"\n[{CONFIG['colors']['info']}]До свидания![/{CONFIG['colors']['info']}]")
        except Exception as e:
            self.console.print(f"[{CONFIG['colors']['error']}]Ошибка: {e}[/{CONFIG['colors']['error']}]")


def main():
    """Точка входа в приложение"""
    # Проверяем наличие необходимых пакетов
    try:
        import rich
        import pyperclip
    except ImportError as e:
        console.print(f"[red]Отсутствует необходимый пакет: {e}[/red]")
        console.print("Установите командой: pip install rich pyperclip")
        return
    
    # Запускаем приложение
    app = DiagnosticsTUIv2()
    app.run()


if __name__ == "__main__":
    main() 