#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Diagnostika RMK - Чек-Лист РМК
Система диагностики кассовых систем
"""

import os
import sys
import json
import datetime
from typing import List, Dict, Any
import paramiko
import mysql.connector
from mysql.connector import Error
import requests
import socket
import subprocess
import threading
import time

class RMKChecklist:
    def __init__(self):
        self.config = self.load_config()
        self.results = []
        self.cash_ip = None
        self.cash_username = None
        self.cash_password = None
        self.server_ip = None
        
    def load_config(self) -> Dict[str, Any]:
        """Загрузка конфигурации"""
        default_config = {
            "database": {
                "host": "localhost",
                "port": 3306,
                "user": "netroot",
                "password": "netroot",
                "database": "cashdb"
            },
            "paths": {
                "ncash_ini": "/opt/linuxcash/cash/conf/ncash.ini",
                "egais_xml": "/opt/linuxcash/cash/conf/plugins/egais_plugins.xml",
                "puppet_ini": "/opt/linuxcash/cash/conf/puppet/markedgoods.ini"
            },
            "ports": {
                "cash": [7795, 5900, 80, 28085, 22],
                "server": [8080, 8084, 10001, 8140]
            },
            "repositories": [
                "http://update.artix.su/bionic",
                "http://update.artix.su/jammy",
                "https://download.docker.com/linux/ubuntu",
                "http://archive.ubuntu.com/ubuntu",
                "http://security.ubuntu.com/ubuntu"
            ]
        }
        
        config_file = "config/rmk_config.json"
        if os.path.exists(config_file):
            try:
                with open(config_file, 'r', encoding='utf-8') as f:
                    return json.load(f)
            except:
                return default_config
        return default_config
    
    def get_user_input(self) -> None:
        """Получение данных от пользователя"""
        print("🔧 Настройка подключения для проверок РМК")
        print("=" * 60)
        
        # Данные для подключения к кассе
        print("\n📡 Подключение к кассе:")
        self.cash_ip = input("IP адрес кассы: ").strip()
        self.cash_username = input("Логин: ").strip()
        self.cash_password = input("Пароль: ").strip()
        
        # IP сервера
        print("\n🖥️  Подключение к серверу:")
        self.server_ip = input("IP адрес сервера: ").strip()
        
        print("\n✅ Данные получены!")
    
    def show_menu(self) -> None:
        """Отображение главного меню"""
        print("\n" + "=" * 60)
        print("           ЧЕК-ЛИСТ РМК - Система диагностики")
        print("=" * 60)
        print("1.  Проверка доступности портов кассы")
        print("2.  Проверка доступности портов сервера")
        print("3.  Проверка доступности репозиториев")
        print("4.  Проверка настройки соотнесения налогов")
        print("5.  Проверка настройки соотнесения типов оплат")
        print("6.  Проверка Puppet")
        print("7.  Проверка плагина маркировки")
        print("8.  Проверка ЛМ ЧЗ")
        print("9.  Проверка EGAIS")
        print("10. Проверка настройки оперативных продаж")
        print("11. Проверка загрузки справочников")
        print("12. Проверка выгрузки продаж")
        print("13. Проверка справочника ролей и действий")
        print("14. Проверка целостности Меню")
        print("15. Проверка оборудования")
        print("16. Проверки через XDTool (8 пунктов)")
        print("17. Запустить все проверки")
        print("18. Выбрать несколько проверок")
        print("0.  Выход")
        print("=" * 60)
    
    def get_check_choice(self) -> str:
        """Получение выбора пользователя"""
        return input("\nВыберите пункт (0-18): ").strip()
    
    def run_single_check(self, check_number: int) -> None:
        """Запуск одной проверки"""
        print(f"\n🔍 Запуск проверки #{check_number}")
        print("=" * 40)
        
        if check_number == 1:
            self.check_cash_ports()
        elif check_number == 2:
            self.check_server_ports()
        elif check_number == 3:
            self.check_repositories()
        elif check_number == 4:
            self.check_tax_mapping()
        elif check_number == 5:
            self.check_payment_mapping()
        elif check_number == 6:
            self.check_puppet()
        elif check_number == 7:
            self.check_marking_plugin()
        elif check_number == 8:
            self.check_lm_chz()
        elif check_number == 9:
            self.check_egais()
        elif check_number == 10:
            self.check_operational_sales()
        elif check_number == 11:
            self.check_dictionary_loading()
        elif check_number == 12:
            self.check_sales_upload()
        elif check_number == 13:
            self.check_roles_actions()
        elif check_number == 14:
            self.check_menu_integrity()
        elif check_number == 15:
            self.check_hardware()
        elif check_number == 16:
            self.check_xdtool()
        else:
            print("❌ Неверный номер проверки")
    
    def run_multiple_checks(self) -> None:
        """Запуск нескольких проверок"""
        print("\n📋 Выбор нескольких проверок")
        print("Введите номера проверок через запятую (например: 1,3,5,7)")
        choices = input("Ваш выбор: ").strip()
        
        try:
            check_numbers = [int(x.strip()) for x in choices.split(',')]
            print(f"\n🚀 Запуск {len(check_numbers)} проверок...")
            
            for check_num in check_numbers:
                if 1 <= check_num <= 16:
                    self.run_single_check(check_num)
                else:
                    print(f"❌ Неверный номер проверки: {check_num}")
            
            # Определяем формат вывода
            if len(check_numbers) <= 3:
                self.print_results_console()
            else:
                self.generate_report_file()
                
        except ValueError:
            print("❌ Ошибка в формате ввода")
    
    def run_all_checks(self) -> None:
        """Запуск всех проверок"""
        print("\n🚀 Запуск всех проверок РМК...")
        print("Это может занять несколько минут...")
        
        all_checks = list(range(1, 17))  # 1-16
        
        for check_num in all_checks:
            self.run_single_check(check_num)
        
        self.generate_report_file()
    
    def check_cash_ports(self) -> None:
        """Проверка доступности портов кассы"""
        print("🔍 Проверка доступности портов кассы...")
        
        if not all([self.cash_ip, self.cash_username, self.cash_password]):
            print("❌ Не указаны данные для подключения к кассе")
            return
        
        try:
            # Подключение через SSH
            ssh = paramiko.SSHClient()
            ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            ssh.connect(self.cash_ip, username=self.cash_username, password=self.cash_password, timeout=10)
            
            print(f"✅ Подключение к кассе {self.cash_ip} установлено")
            
            # Проверка портов
            for port in self.config["ports"]["cash"]:
                result = self.check_port_on_remote(ssh, "localhost", port)
                self.results.append({
                    "check": "Порты кассы",
                    "port": port,
                    "status": "✅ Доступен" if result else "❌ Недоступен",
                    "details": f"Порт {port} на кассе"
                })
            
            ssh.close()
            
        except Exception as e:
            print(f"❌ Ошибка подключения к кассе: {e}")
            self.results.append({
                "check": "Порты кассы",
                "status": "❌ Ошибка подключения",
                "details": str(e)
            })
    
    def check_server_ports(self) -> None:
        """Проверка доступности портов сервера"""
        print("🔍 Проверка доступности портов сервера...")
        
        if not self.server_ip:
            print("❌ Не указан IP сервера")
            return
        
        # Проверка с текущей кассы
        for port in self.config["ports"]["server"]:
            result = self.check_port_local(self.server_ip, port)
            self.results.append({
                "check": "Порты сервера",
                "port": port,
                "status": "✅ Доступен" if result else "❌ Недоступен",
                "details": f"Порт {port} на сервере {self.server_ip}"
            })
    
    def check_repositories(self) -> None:
        """Проверка доступности репозиториев"""
        print("🔍 Проверка доступности репозиториев...")
        
        for repo in self.config["repositories"]:
            result = self.check_repository(repo)
            self.results.append({
                "check": "Репозитории",
                "repository": repo,
                "status": "✅ Доступен" if result else "❌ Недоступен",
                "details": repo
            })
    
    def check_port_on_remote(self, ssh: paramiko.SSHClient, host: str, port: int) -> bool:
        """Проверка порта на удаленной машине"""
        try:
            stdin, stdout, stderr = ssh.exec_command(f"nc -z {host} {port}")
            return stdout.channel.recv_exit_status() == 0
        except:
            return False
    
    def check_port_local(self, host: str, port: int) -> bool:
        """Проверка порта локально"""
        try:
            sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            sock.settimeout(5)
            result = sock.connect_ex((host, port))
            sock.close()
            return result == 0
        except:
            return False
    
    def check_repository(self, url: str) -> bool:
        """Проверка доступности репозитория"""
        try:
            response = requests.get(url, timeout=10)
            return response.status_code == 200
        except:
            return False
    
    def check_tax_mapping(self) -> None:
        """Проверка настройки соотнесения налогов"""
        print("🔍 Проверка настройки соотнесения налогов...")
        # TODO: Реализовать проверку
        self.results.append({
            "check": "Соотнесение налогов",
            "status": "⚠️  Не реализовано",
            "details": "Требуется дополнительная информация"
        })
    
    def check_payment_mapping(self) -> None:
        """Проверка настройки соотнесения типов оплат"""
        print("🔍 Проверка настройки соотнесения типов оплат...")
        # TODO: Реализовать проверку
        self.results.append({
            "check": "Соотнесение типов оплат",
            "status": "⚠️  Не реализовано",
            "details": "Требуется дополнительная информация"
        })
    
    def check_puppet(self) -> None:
        """Проверка Puppet"""
        print("🔍 Проверка Puppet...")
        
        if not all([self.cash_ip, self.cash_username, self.cash_password]):
            print("❌ Не указаны данные для подключения к кассе")
            return
        
        try:
            ssh = paramiko.SSHClient()
            ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            ssh.connect(self.cash_ip, username=self.cash_username, password=self.cash_password, timeout=10)
            
            # Проверка ping puppet
            stdin, stdout, stderr = ssh.exec_command("ping -c 1 puppet")
            if stdout.channel.recv_exit_status() == 0:
                print("✅ Puppet доступен по ping")
                self.results.append({
                    "check": "Puppet ping",
                    "status": "✅ Доступен",
                    "details": "Puppet отвечает на ping"
                })
            else:
                print("⚠️  Puppet недоступен по ping, проверяем /etc/hosts")
                # Проверка /etc/hosts
                stdin, stdout, stderr = ssh.exec_command("grep puppet /etc/hosts")
                hosts_content = stdout.read().decode().strip()
                if hosts_content:
                    print(f"✅ Puppet найден в /etc/hosts: {hosts_content}")
                    self.results.append({
                        "check": "Puppet /etc/hosts",
                        "status": "✅ Настроен",
                        "details": f"Запись в /etc/hosts: {hosts_content}"
                    })
                else:
                    print("❌ Puppet не найден в /etc/hosts")
                    self.results.append({
                        "check": "Puppet /etc/hosts",
                        "status": "❌ Не настроен",
                        "details": "Puppet отсутствует в /etc/hosts"
                    })
            
            # Запуск puppet agent --debug
            print("🔍 Запуск puppet agent --debug...")
            stdin, stdout, stderr = ssh.exec_command("puppet agent --debug", timeout=30)
            puppet_output = stdout.read().decode()
            puppet_errors = stderr.read().decode()
            
            if "Finished catalog run" in puppet_output:
                print("✅ Puppet выполнен успешно")
                self.results.append({
                    "check": "Puppet agent",
                    "status": "✅ Успешно",
                    "details": "Puppet agent выполнен без ошибок"
                })
            else:
                print("❌ Ошибки в Puppet")
                self.results.append({
                    "check": "Puppet agent",
                    "status": "❌ Ошибки",
                    "details": puppet_errors[:200] + "..." if len(puppet_errors) > 200 else puppet_errors
                })
            
            ssh.close()
            
        except Exception as e:
            print(f"❌ Ошибка проверки Puppet: {e}")
            self.results.append({
                "check": "Puppet",
                "status": "❌ Ошибка подключения",
                "details": str(e)
            })
    
    def check_marking_plugin(self) -> None:
        """Проверка плагина маркировки"""
        print("🔍 Проверка плагина маркировки...")
        # TODO: Реализовать проверку
        self.results.append({
            "check": "Плагин маркировки",
            "status": "⚠️  Не реализовано",
            "details": "Требуется дополнительная информация"
        })
    
    def check_lm_chz(self) -> None:
        """Проверка ЛМ ЧЗ"""
        print("🔍 Проверка ЛМ ЧЗ...")
        
        if not all([self.cash_ip, self.cash_username, self.cash_password]):
            print("❌ Не указаны данные для подключения к кассе")
            return
        
        try:
            ssh = paramiko.SSHClient()
            ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            ssh.connect(self.cash_ip, username=self.cash_username, password=self.cash_password, timeout=10)
            
            # Проверка установки dpkg
            stdin, stdout, stderr = ssh.exec_command("dpkg -l | grep regime")
            regime_packages = stdout.read().decode().strip()
            
            if regime_packages:
                print("✅ Пакеты ЛМ ЧЗ установлены")
                self.results.append({
                    "check": "ЛМ ЧЗ установка",
                    "status": "✅ Установлен",
                    "details": f"Найдены пакеты: {regime_packages}"
                })
            else:
                print("❌ Пакеты ЛМ ЧЗ не найдены")
                self.results.append({
                    "check": "ЛМ ЧЗ установка",
                    "status": "❌ Не установлен",
                    "details": "Пакеты regime не найдены"
                })
            
            # Проверка логов на ready
            stdin, stdout, stderr = ssh.exec_command("grep -r 'ready' /var/log/ | grep -i regime | tail -5")
            logs_ready = stdout.read().decode().strip()
            
            if logs_ready:
                print("✅ ЛМ ЧЗ готов (найдено в логах)")
                self.results.append({
                    "check": "ЛМ ЧЗ готовность",
                    "status": "✅ Готов",
                    "details": "Найдено 'ready' в логах"
                })
            else:
                print("⚠️  'ready' не найдено в логах, отправляем запрос инициализации")
                
                # Чтение токена из конфигурации
                stdin, stdout, stderr = ssh.exec_command(f"grep -o 'token.*=.*' {self.config['paths']['ncash_ini']} | head -1")
                token_line = stdout.read().decode().strip()
                
                if token_line:
                    token = token_line.split('=')[1].strip()
                    print(f"✅ Токен найден: {token[:10]}...")
                    
                    # Отправка запроса инициализации
                    init_command = f'''curl -X POST "172.20.0.16:5995/api/v1/init" \
                        -H "Content-Type: application/json" \
                        -H "Authorization: Basic YWRtaW46YWRtaW4=" \
                        -d '{{"token": "{token}"}}' '''
                    
                    stdin, stdout, stderr = ssh.exec_command(init_command)
                    response = stdout.read().decode().strip()
                    
                    if "ready" in response.lower():
                        print("✅ ЛМ ЧЗ инициализирован успешно")
                        self.results.append({
                            "check": "ЛМ ЧЗ инициализация",
                            "status": "✅ Успешно",
                            "details": "Получен ответ 'ready'"
                        })
                    else:
                        print(f"❌ Ошибка инициализации ЛМ ЧЗ: {response}")
                        self.results.append({
                            "check": "ЛМ ЧЗ инициализация",
                            "status": "❌ Ошибка",
                            "details": f"Ответ: {response}"
                        })
                else:
                    print("❌ Токен не найден в конфигурации")
                    self.results.append({
                        "check": "ЛМ ЧЗ токен",
                        "status": "❌ Не найден",
                        "details": "Токен отсутствует в конфигурации"
                    })
            
            ssh.close()
            
        except Exception as e:
            print(f"❌ Ошибка проверки ЛМ ЧЗ: {e}")
            self.results.append({
                "check": "ЛМ ЧЗ",
                "status": "❌ Ошибка подключения",
                "details": str(e)
            })
    
    def check_egais(self) -> None:
        """Проверка EGAIS"""
        print("🔍 Проверка EGAIS...")
        
        if not all([self.cash_ip, self.cash_username, self.cash_password]):
            print("❌ Не указаны данные для подключения к кассе")
            return
        
        try:
            ssh = paramiko.SSHClient()
            ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            ssh.connect(self.cash_ip, username=self.cash_username, password=self.cash_password, timeout=10)
            
            # Проверка наличия файла egais_plugins.xml
            stdin, stdout, stderr = ssh.exec_command(f"test -f {self.config['paths']['egais_xml']} && echo 'exists'")
            if stdout.read().decode().strip() == 'exists':
                print("✅ Файл egais_plugins.xml найден")
                
                # Проверка наличия ИП с окончанием :8080
                stdin, stdout, stderr = ssh.exec_command(f"grep -o '[0-9]\\+\\.[0-9]\\+\\.[0-9]\\+\\.[0-9]\\+:8080' {self.config['paths']['egais_xml']}")
                ip_entries = stdout.read().decode().strip()
                
                if ip_entries:
                    print(f"✅ Найдены ИП с портом 8080: {ip_entries}")
                    self.results.append({
                        "check": "EGAIS конфигурация",
                        "status": "✅ Настроен",
                        "details": f"Найдены ИП: {ip_entries}"
                    })
                else:
                    print("❌ ИП с портом 8080 не найдены")
                    self.results.append({
                        "check": "EGAIS конфигурация",
                        "status": "❌ Не настроен",
                        "details": "ИП с портом 8080 отсутствуют"
                    })
            else:
                print("❌ Файл egais_plugins.xml не найден")
                self.results.append({
                    "check": "EGAIS файл",
                    "status": "❌ Не найден",
                    "details": f"Файл {self.config['paths']['egais_xml']} отсутствует"
                })
            
            ssh.close()
            
        except Exception as e:
            print(f"❌ Ошибка проверки EGAIS: {e}")
            self.results.append({
                "check": "EGAIS",
                "status": "❌ Ошибка подключения",
                "details": str(e)
            })
    
    def check_operational_sales(self) -> None:
        """Проверка настройки оперативных продаж"""
        print("🔍 Проверка настройки оперативных продаж...")
        
        try:
            # Подключение к MySQL
            connection = mysql.connector.connect(
                host=self.config["database"]["host"],
                port=self.config["database"]["port"],
                user=self.config["database"]["user"],
                password=self.config["database"]["password"],
                database=self.config["database"]["database"]
            )
            
            if connection.is_connected():
                cursor = connection.cursor()
                
                # Проверка таблицы macros
                cursor.execute("SELECT * FROM macros WHERE name LIKE '%почековая выгрузка%'")
                macros_results = cursor.fetchall()
                
                if macros_results:
                    print("✅ Параметр 'почековая выгрузка' найден в таблице macros")
                    self.results.append({
                        "check": "Оперативные продажи - macros",
                        "status": "✅ Настроен",
                        "details": f"Найдено записей: {len(macros_results)}"
                    })
                else:
                    print("❌ Параметр 'почековая выгрузка' не найден в таблице macros")
                    self.results.append({
                        "check": "Оперативные продажи - macros",
                        "status": "❌ Не настроен",
                        "details": "Параметр отсутствует в таблице macros"
                    })
                
                # Проверка таблицы события
                cursor.execute("SHOW TABLES LIKE 'события'")
                if cursor.fetchone():
                    cursor.execute("SELECT COUNT(*) FROM события")
                    events_count = cursor.fetchone()[0]
                    print(f"✅ Таблица 'события' найдена, записей: {events_count}")
                    self.results.append({
                        "check": "Оперативные продажи - события",
                        "status": "✅ Настроен",
                        "details": f"Найдено событий: {events_count}"
                    })
                else:
                    print("❌ Таблица 'события' не найдена")
                    self.results.append({
                        "check": "Оперативные продажи - события",
                        "status": "❌ Не настроен",
                        "details": "Таблица 'события' отсутствует"
                    })
                
                cursor.close()
                connection.close()
                
        except Error as e:
            print(f"❌ Ошибка подключения к БД: {e}")
            self.results.append({
                "check": "Оперативные продажи - БД",
                "status": "❌ Ошибка подключения",
                "details": str(e)
            })
    
    def check_dictionary_loading(self) -> None:
        """Проверка загрузки справочников"""
        print("🔍 Проверка загрузки справочников...")
        # TODO: Реализовать проверку
        self.results.append({
            "check": "Загрузка справочников",
            "status": "⚠️  Не реализовано",
            "details": "Требуется дополнительная информация"
        })
    
    def check_sales_upload(self) -> None:
        """Проверка выгрузки продаж"""
        print("🔍 Проверка выгрузки продаж...")
        # TODO: Реализовать проверку
        self.results.append({
            "check": "Выгрузка продаж",
            "status": "⚠️  Не реализовано",
            "details": "Требуется дополнительная информация"
        })
    
    def check_roles_actions(self) -> None:
        """Проверка справочника ролей и действий"""
        print("🔍 Проверка справочника ролей и действий...")
        # TODO: Реализовать проверку
        self.results.append({
            "check": "Справочник ролей и действий",
            "status": "⚠️  Не реализовано",
            "details": "Требуется дополнительная информация"
        })
    
    def check_menu_integrity(self) -> None:
        """Проверка целостности Меню"""
        print("🔍 Проверка целостности Меню...")
        # TODO: Реализовать проверку
        self.results.append({
            "check": "Целостность Меню",
            "status": "⚠️  Не реализовано",
            "details": "Требуется дополнительная информация"
        })
    
    def check_hardware(self) -> None:
        """Проверка оборудования"""
        print("🔍 Проверка оборудования...")
        print("Для корректной проверки оборудования нужна дополнительная информация:")
        
        equipment_types = ["Сканер", "ФР", "Пинпад", "Весы", "ДП"]
        
        for equipment in equipment_types:
            print(f"\n{equipment}:")
            model = input(f"  Модель {equipment.lower()}а: ").strip()
            protocol = input(f"  Протокол подключения: ").strip()
            
            if model and protocol:
                print(f"  ✅ {equipment} будет проверен")
                self.results.append({
                    "check": f"Оборудование - {equipment}",
                    "status": "⚠️  Требует настройки",
                    "details": f"Модель: {model}, Протокол: {protocol}"
                })
            else:
                print(f"  ⚠️  {equipment} пропущен")
    
    def check_xdtool(self) -> None:
        """Проверки через XDTool"""
        print("🔍 Проверки через XDTool...")
        print("8 пунктов проверки через имитацию действий кассира:")
        
        xdtool_checks = [
            "Открытие кассы",
            "Регистрация товара",
            "Применение скидки",
            "Оплата наличными",
            "Оплата картой",
            "Возврат товара",
            "Закрытие смены",
            "Печать отчета"
        ]
        
        for i, check in enumerate(xdtool_checks, 1):
            print(f"{i}. {check}")
            # TODO: Реализовать проверки через xdtool
            self.results.append({
                "check": f"XDTool - {check}",
                "status": "⚠️  Не реализовано",
                "details": "Требуется интеграция с xdtool"
            })
    
    def print_results_console(self) -> None:
        """Вывод результатов в консоль"""
        print("\n" + "=" * 60)
        print("                    РЕЗУЛЬТАТЫ ПРОВЕРОК")
        print("=" * 60)
        
        for result in self.results:
            print(f"\n{result['check']}: {result['status']}")
            if 'details' in result:
                print(f"  Детали: {result['details']}")
    
    def generate_report_file(self) -> None:
        """Генерация файла-отчета"""
        timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
        filename = f"reports/rmk_report_{timestamp}.txt"
        
        # Создаем папку reports если её нет
        os.makedirs("reports", exist_ok=True)
        
        with open(filename, 'w', encoding='utf-8') as f:
            f.write("=" * 60 + "\n")
            f.write("                    ОТЧЕТ ПРОВЕРОК РМК\n")
            f.write("=" * 60 + "\n")
            f.write(f"Дата: {datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
            f.write(f"Касса: {self.cash_ip}\n")
            f.write(f"Сервер: {self.server_ip}\n")
            f.write("=" * 60 + "\n\n")
            
            for result in self.results:
                f.write(f"{result['check']}: {result['status']}\n")
                if 'details' in result:
                    f.write(f"  Детали: {result['details']}\n")
                f.write("\n")
        
        print(f"\n📄 Отчет сохранен в файл: {filename}")
    
    def run(self) -> None:
        """Основной цикл программы"""
        print("🚀 Запуск Чек-Лист РМК...")
        
        # Получение данных от пользователя
        self.get_user_input()
        
        while True:
            self.show_menu()
            choice = self.get_check_choice()
            
            if choice == "0":
                print("👋 До свидания!")
                break
            elif choice == "17":
                self.run_all_checks()
                break
            elif choice == "18":
                self.run_multiple_checks()
                break
            elif choice.isdigit() and 1 <= int(choice) <= 16:
                self.run_single_check(int(choice))
                
                # Определяем формат вывода для одной проверки
                if len(self.results) <= 3:
                    self.print_results_console()
                else:
                    self.generate_report_file()
                break
            else:
                print("❌ Неверный выбор. Попробуйте снова.")

if __name__ == "__main__":
    try:
        checklist = RMKChecklist()
        checklist.run()
    except KeyboardInterrupt:
        print("\n\n👋 Программа прервана пользователем")
    except Exception as e:
        print(f"\n❌ Критическая ошибка: {e}")
        sys.exit(1) 