#!/usr/bin/env python3
"""
Linux Server Diagnostics TUI Tool v2.0
Модульная архитектура для легкого расширения функционала
"""

import os
import sys
import json
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

# Импортируем нашу модульную систему
from core.module_manager import ModuleManager

# Инициализация Rich консоли
console = Console()

# Конфигурация приложения
CONFIG = {
    "title": "Диагностика Linux Серверов v2.0",
    "version": "2.0",
    "author": "Модульная система диагностики",
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


class DiagnosticsTUIv2:
    """Улучшенная версия TUI с модульной архитектурой"""
    
    def __init__(self):
        self.console = console
        self.module_manager = ModuleManager()
        self.current_menu = {}
        self.menu_stack = []
        self.selected_index = 0
        self.command_history = []
        
    def show_header(self):
        """Отображает заголовок приложения"""
        title = f" {CONFIG['title']} v{CONFIG['version']} "
        subtitle = f" Загружено модулей: {len(self.module_manager.modules)} "
        
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
                    description = f"{len(value)} подкатегорий"
                else:
                    item_type = "▶ Команда"
                    description = "Выполнить команду"
                
                style = f"bold {CONFIG['colors']['secondary']}" if i == self.selected_index else "white"
                table.add_row(f"  {key}", item_type, description, style=style)
            
            self.console.print(table)
            
            # Справка по навигации
            help_text = Text(
                "Навигация: W/S или ↑/↓ - Выбор | Enter - Выполнить | Q - Выход | M - Модули | H - История",
                style=f"dim {CONFIG['colors']['info']}"
            )
            self.console.print(help_text)
            
            # Обработка ввода пользователя
            try:
                key = self.console.input("").lower()
                
                if key == 'q':
                    return
                elif key == 'm':
                    self.show_modules_menu()
                    continue
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
        options_table.add_row("4", "Добавить в пользовательские команды")
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
            elif choice == '4':
                self._add_to_custom_commands(command, description)
                break
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
    
    def _add_to_custom_commands(self, command: str, description: str):
        """Добавляет команду в пользовательские команды"""
        try:
            if "custom" in self.module_manager.modules:
                custom_module = self.module_manager.modules["custom"]
                if hasattr(custom_module, 'add_command'):
                    category = Prompt.ask("Введите категорию", default="Мои команды")
                    subcategory = Prompt.ask("Введите подкатегорию", default="Добавленные")
                    
                    if custom_module.add_command(category, subcategory, description, command):
                        self.console.print(f"[{CONFIG['colors']['success']}]✓ Команда добавлена в пользовательские команды[/{CONFIG['colors']['success']}]")
                    else:
                        self.console.print(f"[{CONFIG['colors']['error']}]✗ Не удалось добавить команду[/{CONFIG['colors']['error']}]")
                else:
                    self.console.print(f"[{CONFIG['colors']['error']}]Модуль пользовательских команд не поддерживает добавление[/{CONFIG['colors']['error']}]")
            else:
                self.console.print(f"[{CONFIG['colors']['error']}]Модуль пользовательских команд не загружен[/{CONFIG['colors']['error']}]")
        except Exception as e:
            self.console.print(f"[{CONFIG['colors']['error']}]Ошибка добавления команды: {e}[/{CONFIG['colors']['error']}]")
        
        self.console.input("Нажмите Enter для продолжения...")
    
    def show_modules_menu(self):
        """Показывает меню управления модулями"""
        self.console.clear()
        self.show_header()
        
        modules_info = self.module_manager.get_module_info()
        
        table = Table(
            title=" Управление модулями ",
            show_header=True,
            box=box.ROUNDED,
            style=f"bold {CONFIG['colors']['primary']}"
        )
        
        table.add_column("Модуль", style="white")
        table.add_column("Статус", style="white")
        table.add_column("Команд", style="white")
        table.add_column("Описание", style="dim")
        
        for module in modules_info:
            status = "✅ Включен" if module["enabled"] else "❌ Отключен"
            table.add_row(
                f"{module['icon']} {module['name']}",
                status,
                str(module["commands_count"]),
                module["description"]
            )
        
        self.console.print(table)
        
        help_text = Text(
            "E - Включить модуль | D - Отключить модуль | R - Перезагрузить | Enter - Вернуться",
            style=f"dim {CONFIG['colors']['info']}"
        )
        self.console.print(help_text)
        
        while True:
            choice = self.console.input("Выберите действие: ").lower()
            
            if choice == 'e':
                module_id = Prompt.ask("Введите ID модуля для включения")
                if self.module_manager.enable_module(module_id):
                    self.console.print(f"[{CONFIG['colors']['success']}]✓ Модуль {module_id} включен[/{CONFIG['colors']['success']}]")
                else:
                    self.console.print(f"[{CONFIG['colors']['error']}]✗ Не удалось включить модуль {module_id}[/{CONFIG['colors']['error']}]")
                break
            elif choice == 'd':
                module_id = Prompt.ask("Введите ID модуля для отключения")
                if self.module_manager.disable_module(module_id):
                    self.console.print(f"[{CONFIG['colors']['success']}]✓ Модуль {module_id} отключен[/{CONFIG['colors']['success']}]")
                else:
                    self.console.print(f"[{CONFIG['colors']['error']}]✗ Не удалось отключить модуль {module_id}[/{CONFIG['colors']['error']}]")
                break
            elif choice == 'r':
                self.module_manager.reload_modules()
                self.console.print(f"[{CONFIG['colors']['success']}]✓ Модули перезагружены[/{CONFIG['colors']['success']}]")
                break
            elif choice in ['', 'enter']:
                break
    
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
            # Загружаем команды из всех модулей
            all_commands = self.module_manager.get_all_commands()
            
            if not all_commands:
                self.console.print(f"[{CONFIG['colors']['error']}]Не удалось загрузить команды из модулей[/{CONFIG['colors']['error']}]")
                return
            
            self.show_menu(all_commands, "Главное меню")
            
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