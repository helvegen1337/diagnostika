#!/usr/bin/env python3
"""
Пример плагина для системы диагностики
Демонстрирует как создавать собственные плагины
"""

from core.module_base import ModuleBase
from typing import Dict, Any


class ExamplePlugin(ModuleBase):
    """Пример плагина с дополнительными функциями"""
    
    def __init__(self, config: Dict[str, Any]):
        super().__init__(config)
        self.version = "1.0"
        self.author = "Plugin Developer"
    
    def get_commands(self) -> Dict[str, Any]:
        """Возвращает команды для плагина"""
        return {
            "Пример плагина": {
                "Демонстрационные команды": {
                    "Показать версию системы": "cat /etc/os-release",
                    "Информация о процессоре": "lscpu",
                    "Информация о памяти": "free -h && echo '---' && cat /proc/meminfo | head -10",
                    "Загрузка системы": "uptime && echo '---' && w",
                    "Информация о пользователях": "who && echo '---' && last | head -5"
                },
                "Пользовательские функции": {
                    "Мой скрипт 1": "echo 'Это мой первый скрипт' && date",
                    "Мой скрипт 2": "echo 'Это мой второй скрипт' && whoami",
                    "Проверка сервисов": "systemctl list-units --type=service --state=running | head -10",
                    "Статистика процессов": "ps aux | wc -l && echo '---' && ps aux --sort=-%cpu | head -5"
                }
            }
        }
    
    def get_command_help(self, command: str) -> str:
        """Возвращает справку по команде"""
        help_texts = {
            "cat /etc/os-release": "Показывает информацию о версии операционной системы",
            "lscpu": "Показывает детальную информацию о процессоре",
            "uptime": "Показывает время работы системы и среднюю нагрузку"
        }
        return help_texts.get(command, "Это команда из примера плагина")
    
    def pre_execute_hook(self, command: str, description: str) -> bool:
        """Хук перед выполнением команды"""
        print(f"[ПЛАГИН] Выполняется команда: {description}")
        return True
    
    def post_execute_hook(self, command: str, description: str, result: Any) -> None:
        """Хук после выполнения команды"""
        if result and "returncode" in result:
            if result["returncode"] == 0:
                print(f"[ПЛАГИН] Команда {description} выполнена успешно")
            else:
                print(f"[ПЛАГИН] Команда {description} завершилась с ошибкой") 