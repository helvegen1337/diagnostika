#!/usr/bin/env python3
"""
Модуль диагностики дисков и хранилища
"""

from core.module_base import ModuleBase
from typing import Dict, Any


class StorageModule(ModuleBase):
    """Модуль для диагностики дисков и хранилища"""
    
    def __init__(self, config: Dict[str, Any]):
        super().__init__(config)
        self.version = "1.0"
        self.author = "Diagnostika Team"
    
    def get_commands(self) -> Dict[str, Any]:
        """Возвращает команды для диагностики дисков"""
        return {
            "Использование дисков": {
                "Основная информация": {
                    "Обзор места на дисках": "df -h",
                    "Использование inode": "df -i",
                    "Самые большие директории": "du -h --max-depth=1 / | sort -hr",
                    "Найти большие файлы": "find / -type f -size +100M -exec ls -lh {} \\; 2>/dev/null",
                    "Точки монтирования": "mount | column -t",
                    "Статистика I/O дисков": "iostat -x 1 3",
                    "Здоровье диска": "smartctl -a /dev/sda"
                },
                "Детальный анализ": {
                    "Топ пользователей диска": "du -sh /* 2>/dev/null | sort -hr | head -10",
                    "Недавние большие файлы": "find / -type f -mtime -7 -size +50M -exec ls -lh {} \\; 2>/dev/null",
                    "Размеры лог файлов": "du -sh /var/log/* 2>/dev/null | sort -hr",
                    "Временные файлы": "du -sh /tmp/* 2>/dev/null | sort -hr | head -10",
                    "Файлы старше 30 дней": "find / -type f -mtime +30 -size +10M -exec ls -lh {} \\; 2>/dev/null | head -10"
                }
            },
            "Анализ хранилища": {
                "Файловые системы": {
                    "Типы файловых систем": "df -T",
                    "Информация о блочных устройствах": "lsblk",
                    "LVM информация": "lvs && vgs && pvs",
                    "RAID статус": "cat /proc/mdstat",
                    "Информация о дисках": "fdisk -l"
                },
                "Производительность": {
                    "I/O статистика": "iostat -x 1 5",
                    "Мониторинг I/O": "iotop -o -b -n 3",
                    "Статистика чтения/записи": "cat /proc/diskstats",
                    "Кэш диска": "cat /proc/sys/vm/dirty_ratio",
                    "Нагрузка на диски": "iostat -d 1 3"
                }
            },
            "Очистка и оптимизация": {
                "Очистка кэша": {
                    "Очистить кэш страниц": "sync && echo 1 > /proc/sys/vm/drop_caches",
                    "Очистить dentries и inodes": "sync && echo 2 > /proc/sys/vm/drop_caches",
                    "Очистить все кэши": "sync && echo 3 > /proc/sys/vm/drop_caches",
                    "Найти старые файлы": "find /tmp -type f -atime +7 -delete",
                    "Очистить журналы": "journalctl --vacuum-time=7d"
                },
                "Анализ места": {
                    "Самые большие файлы в системе": "find / -type f -size +100M -exec ls -lh {} \\; 2>/dev/null | sort -k5 -hr",
                    "Дублирующиеся файлы": "find / -type f -exec md5sum {} \\; 2>/dev/null | sort | uniq -w32 -dD",
                    "Неиспользуемые пакеты": "apt list --installed | grep -v '\\[installed\\]'",
                    "Старые ядра": "dpkg -l | grep linux-image | grep -v $(uname -r)"
                }
            }
        }
    
    def get_command_help(self, command: str) -> str:
        """Возвращает справку по команде"""
        help_texts = {
            "df -h": "Показывает использование дискового пространства в человекочитаемом формате",
            "du -h --max-depth=1 /": "Показывает размер директорий первого уровня",
            "iostat -x 1 3": "Показывает статистику I/O дисков каждую секунду 3 раза",
            "smartctl -a /dev/sda": "Показывает информацию о здоровье диска"
        }
        return help_texts.get(command, "Нет справки для этой команды")
    
    def pre_execute_hook(self, command: str, description: str) -> bool:
        """Проверки перед выполнением команд дисков"""
        # Блокируем опасные команды
        dangerous_commands = [
            "mkfs", "fdisk", "dd if=", "rm -rf /", "format"
        ]
        for dangerous in dangerous_commands:
            if dangerous in command.lower():
                return False
        return True 