#!/usr/bin/env python3
"""
Менеджер модулей для системы диагностики
Автоматически загружает и управляет модулями
"""

import os
import sys
import json
import importlib
import importlib.util
from typing import Dict, Any, List, Optional
from pathlib import Path
from core.module_base import ModuleBase, CustomCommandsModule


class ModuleManager:
    """Менеджер для загрузки и управления модулями"""
    
    def __init__(self, config_file: str = "config/modules.json"):
        self.config_file = config_file
        self.modules: Dict[str, ModuleBase] = {}
        self.config: Dict[str, Any] = {}
        self.load_config()
        self.load_modules()
    
    def load_config(self) -> None:
        """Загружает конфигурацию модулей"""
        try:
            if os.path.exists(self.config_file):
                with open(self.config_file, 'r', encoding='utf-8') as f:
                    self.config = json.load(f)
            else:
                print(f"Файл конфигурации {self.config_file} не найден")
                self.config = {"modules": {}, "settings": {}}
        except Exception as e:
            print(f"Ошибка загрузки конфигурации: {e}")
            self.config = {"modules": {}, "settings": {}}
    
    def load_modules(self) -> None:
        """Загружает все доступные модули"""
        # Загружаем встроенные модули
        self._load_builtin_modules()
        
        # Загружаем плагины если включено
        if self.config.get("settings", {}).get("enable_plugins", True):
            self._load_plugin_modules()
    
    def _load_builtin_modules(self) -> None:
        """Загружает встроенные модули"""
        builtin_modules = {
            "network": "modules.network_module.NetworkModule",
            "storage": "modules.storage_module.StorageModule", 
            "system": "modules.system_module.SystemModule",
            "security": "modules.security_module.SecurityModule",
            "performance": "modules.performance_module.PerformanceModule",
            "docker": "modules.docker_module.DockerModule",
            "database": "modules.database_module.DatabaseModule",
            "web": "modules.web_module.WebModule",
            "backup": "modules.backup_module.BackupModule"
        }
        
        for module_id, module_path in builtin_modules.items():
            if self._is_module_enabled(module_id):
                self._load_module(module_id, module_path)
        
        # Загружаем пользовательские команды
        if self._is_module_enabled("custom"):
            custom_commands_file = self.config.get("settings", {}).get(
                "custom_commands_file", "config/custom_commands.json"
            )
            self.modules["custom"] = CustomCommandsModule(
                self.config["modules"]["custom"], 
                custom_commands_file
            )
    
    def _load_plugin_modules(self) -> None:
        """Загружает модули-плагины из директории plugins"""
        plugin_dir = self.config.get("settings", {}).get("plugin_directory", "plugins")
        
        if not os.path.exists(plugin_dir):
            return
        
        for plugin_file in os.listdir(plugin_dir):
            if plugin_file.endswith('.py') and not plugin_file.startswith('__'):
                plugin_path = os.path.join(plugin_dir, plugin_file)
                self._load_plugin(plugin_path)
    
    def _load_plugin(self, plugin_path: str) -> None:
        """Загружает отдельный плагин"""
        try:
            spec = importlib.util.spec_from_file_location("plugin", plugin_path)
            if spec and spec.loader:
                module = importlib.util.module_from_spec(spec)
                spec.loader.exec_module(module)
                
                # Ищем класс модуля в плагине
                for attr_name in dir(module):
                    attr = getattr(module, attr_name)
                    if (isinstance(attr, type) and 
                        issubclass(attr, ModuleBase) and 
                        attr != ModuleBase):
                        
                        # Получаем конфигурацию для плагина
                        plugin_name = os.path.splitext(os.path.basename(plugin_path))[0]
                        config = self.config.get("modules", {}).get(plugin_name, {})
                        
                        # Создаем экземпляр модуля
                        module_instance = attr(config)
                        self.modules[plugin_name] = module_instance
                        print(f"Загружен плагин: {plugin_name}")
                        break
                        
        except Exception as e:
            print(f"Ошибка загрузки плагина {plugin_path}: {e}")
    
    def _load_module(self, module_id: str, module_path: str) -> None:
        """Загружает встроенный модуль"""
        try:
            module_name, class_name = module_path.rsplit('.', 1)
            module = importlib.import_module(module_name)
            module_class = getattr(module, class_name)
            
            config = self.config.get("modules", {}).get(module_id, {})
            self.modules[module_id] = module_class(config)
            
        except Exception as e:
            print(f"Ошибка загрузки модуля {module_id}: {e}")
    
    def _is_module_enabled(self, module_id: str) -> bool:
        """Проверяет, включен ли модуль"""
        module_config = self.config.get("modules", {}).get(module_id, {})
        return module_config.get("enabled", True)
    
    def get_all_commands(self) -> Dict[str, Any]:
        """Возвращает все команды из всех модулей"""
        all_commands = {}
        
        # Сортируем модули по приоритету
        sorted_modules = sorted(
            self.modules.items(),
            key=lambda x: x[1].priority
        )
        
        for module_id, module in sorted_modules:
            if module.enabled:
                commands = module.get_commands()
                # Добавляем иконку к названию категории
                for category, subcategories in commands.items():
                    category_with_icon = f"{module.icon} {category}"
                    all_commands[category_with_icon] = subcategories
        
        return all_commands
    
    def get_module_info(self) -> List[Dict[str, Any]]:
        """Возвращает информацию о всех модулях"""
        module_info = []
        
        for module_id, module in self.modules.items():
            info = module.get_module_info()
            info["id"] = module_id
            info["enabled"] = module.enabled
            module_info.append(info)
        
        return sorted(module_info, key=lambda x: x["priority"])
    
    def execute_command(self, command: str, description: str) -> Optional[Any]:
        """Выполняет команду через соответствующий модуль"""
        # Находим модуль, который содержит эту команду
        for module in self.modules.values():
            if module.enabled:
                commands = module.get_commands()
                if self._command_in_module(commands, command):
                    # Выполняем хуки модуля
                    if module.pre_execute_hook(command, description):
                        result = self._execute_command_internal(command)
                        module.post_execute_hook(command, description, result)
                        return result
                    else:
                        print("Команда заблокирована модулем")
                        return None
        
        # Если команда не найдена в модулях, выполняем напрямую
        return self._execute_command_internal(command)
    
    def _command_in_module(self, commands: Dict[str, Any], target_command: str) -> bool:
        """Проверяет, содержится ли команда в модуле"""
        for category in commands.values():
            if isinstance(category, dict):
                for subcategory in category.values():
                    if isinstance(subcategory, dict):
                        if target_command in subcategory.values():
                            return True
        return False
    
    def _execute_command_internal(self, command: str) -> Optional[Any]:
        """Внутреннее выполнение команды"""
        import subprocess
        try:
            result = subprocess.run(
                command, 
                shell=True, 
                capture_output=True, 
                text=True, 
                timeout=30
            )
            return {
                "returncode": result.returncode,
                "stdout": result.stdout,
                "stderr": result.stderr
            }
        except subprocess.TimeoutExpired:
            return {"error": "Команда превысила время ожидания"}
        except Exception as e:
            return {"error": str(e)}
    
    def reload_modules(self) -> None:
        """Перезагружает все модули"""
        self.modules.clear()
        self.load_config()
        self.load_modules()
    
    def enable_module(self, module_id: str) -> bool:
        """Включает модуль"""
        if module_id in self.config.get("modules", {}):
            self.config["modules"][module_id]["enabled"] = True
            self._save_config()
            self.reload_modules()
            return True
        return False
    
    def disable_module(self, module_id: str) -> bool:
        """Отключает модуль"""
        if module_id in self.config.get("modules", {}):
            self.config["modules"][module_id]["enabled"] = False
            self._save_config()
            self.reload_modules()
            return True
        return False
    
    def _save_config(self) -> None:
        """Сохраняет конфигурацию"""
        try:
            with open(self.config_file, 'w', encoding='utf-8') as f:
                json.dump(self.config, f, ensure_ascii=False, indent=2)
        except Exception as e:
            print(f"Ошибка сохранения конфигурации: {e}") 