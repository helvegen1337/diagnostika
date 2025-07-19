#!/usr/bin/env python3
"""
Базовый класс для модулей диагностики
Все модули должны наследоваться от этого класса
"""

from abc import ABC, abstractmethod
from typing import Dict, Any, List, Optional
import json
import os
from pathlib import Path


class ModuleBase(ABC):
    """Базовый класс для всех модулей диагностики"""
    
    def __init__(self, config: Dict[str, Any]):
        self.config = config
        self.name = config.get('name', 'Неизвестный модуль')
        self.description = config.get('description', '')
        self.icon = config.get('icon', '📁')
        self.priority = config.get('priority', 999)
        self.enabled = config.get('enabled', True)
        
    @abstractmethod
    def get_commands(self) -> Dict[str, Any]:
        """
        Возвращает словарь команд для модуля
        Формат: {"Категория": {"Подкатегория": {"Описание": "команда"}}}
        """
        pass
    
    def get_menu_structure(self) -> Dict[str, Any]:
        """Возвращает структуру меню с метаданными"""
        commands = self.get_commands()
        return {
            "name": self.name,
            "description": self.description,
            "icon": self.icon,
            "priority": self.priority,
            "enabled": self.enabled,
            "commands": commands
        }
    
    def validate_command(self, command: str) -> bool:
        """Проверяет валидность команды"""
        if not command or not isinstance(command, str):
            return False
        
        # Базовые проверки безопасности
        dangerous_commands = ['rm -rf', 'dd if=', 'mkfs', 'fdisk']
        for dangerous in dangerous_commands:
            if dangerous in command.lower():
                return False
        
        return True
    
    def get_command_help(self, command: str) -> Optional[str]:
        """Возвращает справку по команде"""
        return None
    
    def pre_execute_hook(self, command: str, description: str) -> bool:
        """Хук, выполняемый перед выполнением команды"""
        return True
    
    def post_execute_hook(self, command: str, description: str, result: Any) -> None:
        """Хук, выполняемый после выполнения команды"""
        pass
    
    def get_module_info(self) -> Dict[str, Any]:
        """Возвращает информацию о модуле"""
        return {
            "name": self.name,
            "description": self.description,
            "icon": self.icon,
            "version": getattr(self, 'version', '1.0'),
            "author": getattr(self, 'author', 'Unknown'),
            "commands_count": self._count_commands()
        }
    
    def _count_commands(self) -> int:
        """Подсчитывает количество команд в модуле"""
        commands = self.get_commands()
        count = 0
        for category in commands.values():
            if isinstance(category, dict):
                for subcategory in category.values():
                    if isinstance(subcategory, dict):
                        count += len(subcategory)
        return count


class CustomCommandsModule(ModuleBase):
    """Модуль для пользовательских команд"""
    
    def __init__(self, config: Dict[str, Any], custom_commands_file: str):
        super().__init__(config)
        self.custom_commands_file = custom_commands_file
        self._commands_cache = None
        self._cache_time = 0
    
    def get_commands(self) -> Dict[str, Any]:
        """Загружает пользовательские команды из файла"""
        try:
            if os.path.exists(self.custom_commands_file):
                with open(self.custom_commands_file, 'r', encoding='utf-8') as f:
                    return json.load(f)
        except Exception as e:
            print(f"Ошибка загрузки пользовательских команд: {e}")
        
        return {"Пользовательские команды": {"Ошибка": {"Не удалось загрузить": "echo 'Ошибка загрузки'"}}}
    
    def add_command(self, category: str, subcategory: str, description: str, command: str) -> bool:
        """Добавляет новую команду"""
        try:
            commands = self.get_commands()
            
            if category not in commands:
                commands[category] = {}
            
            if subcategory not in commands[category]:
                commands[category][subcategory] = {}
            
            commands[category][subcategory][description] = command
            
            # Сохраняем в файл
            with open(self.custom_commands_file, 'w', encoding='utf-8') as f:
                json.dump(commands, f, ensure_ascii=False, indent=2)
            
            # Сбрасываем кэш
            self._commands_cache = None
            
            return True
        except Exception as e:
            print(f"Ошибка добавления команды: {e}")
            return False 