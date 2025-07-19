#!/usr/bin/env python3
"""
Модуль сетевой диагностики
"""

from core.module_base import ModuleBase
from typing import Dict, Any


class NetworkModule(ModuleBase):
    """Модуль для диагностики сети"""
    
    def __init__(self, config: Dict[str, Any]):
        super().__init__(config)
        self.version = "1.0"
        self.author = "Diagnostika Team"
    
    def get_commands(self) -> Dict[str, Any]:
        """Возвращает команды для сетевой диагностики"""
        return {
            "Сетевые интерфейсы": {
                "Основная информация": {
                    "Показать все интерфейсы": "ip addr show",
                    "Показать таблицу маршрутизации": "ip route show",
                    "Показать ARP таблицу": "ip neigh show",
                    "Сетевая статистика": "ss -tuln",
                    "DNS разрешение": "nslookup google.com",
                    "Тест ping": "ping -c 4 8.8.8.8",
                    "Traceroute": "traceroute google.com",
                    "Сетевые соединения": "netstat -tuln",
                    "Статус файрвола": "iptables -L -n",
                    "Пропускная способность сети": "iftop"
                },
                "Детальная диагностика": {
                    "Информация о сетевых картах": "lspci | grep -i network",
                    "Настройки сетевых интерфейсов": "ip link show",
                    "Статистика пакетов": "cat /proc/net/dev",
                    "Маршруты IPv6": "ip -6 route show",
                    "DNS серверы": "cat /etc/resolv.conf",
                    "Файл hosts": "cat /etc/hosts"
                }
            },
            "Диагностика сети": {
                "Конфигурация": {
                    "Проверить DNS": "cat /etc/resolv.conf",
                    "Проверить файл hosts": "cat /etc/hosts",
                    "Конфигурация сети": "cat /etc/network/interfaces",
                    "Systemd сеть": "systemctl status systemd-networkd",
                    "Network manager": "systemctl status NetworkManager"
                },
                "Тестирование": {
                    "Тест локального соединения": "ping -c 3 127.0.0.1",
                    "Тест шлюза": "ping -c 3 $(ip route | grep default | awk '{print $3}')",
                    "Тест DNS": "nslookup google.com 8.8.8.8",
                    "Проверка портов": "netstat -tuln | grep LISTEN",
                    "Тест скорости": "curl -o /dev/null -s -w '%{speed_download}' https://speed.cloudflare.com/__down"
                }
            },
            "Мониторинг сети": {
                "Активные соединения": {
                    "Текущие TCP соединения": "ss -tuln",
                    "Процессы использующие сеть": "lsof -i",
                    "Статистика по протоколам": "netstat -s",
                    "Мониторинг трафика": "iftop -t -s 10",
                    "Активные порты": "netstat -tuln | grep LISTEN"
                },
                "Логи и безопасность": {
                    "SSH попытки входа": "grep 'sshd' /var/log/auth.log | tail -10",
                    "Неудачные подключения": "grep 'Failed' /var/log/auth.log | tail -10",
                    "Подозрительная активность": "grep -i 'error\|failed\|denied' /var/log/syslog | tail -10"
                }
            }
        }
    
    def get_command_help(self, command: str) -> str:
        """Возвращает справку по команде"""
        help_texts = {
            "ip addr show": "Показывает информацию о всех сетевых интерфейсах",
            "ip route show": "Отображает таблицу маршрутизации",
            "ss -tuln": "Показывает активные сетевые соединения",
            "ping -c 4 8.8.8.8": "Тестирует соединение с Google DNS",
            "traceroute google.com": "Показывает путь пакетов до цели"
        }
        return help_texts.get(command, "Нет справки для этой команды")
    
    def pre_execute_hook(self, command: str, description: str) -> bool:
        """Проверки перед выполнением сетевых команд"""
        # Дополнительные проверки для сетевых команд
        if "iptables" in command and "flush" in command.lower():
            return False  # Блокируем опасные команды
        return True 