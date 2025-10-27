#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Test API Client - Cliente de testes para APIs
Autor: Manus AI
Data: 27/10/2025

Testa endpoints de API e gera relatórios de desempenho.
"""

import requests
import json
import time
import sys
from datetime import datetime
from typing import Dict, Any, Optional

# Cores para terminal
class Colors:
    GREEN = '\033[92m'
    RED = '\033[91m'
    YELLOW = '\033[93m'
    BLUE = '\033[94m'
    CYAN = '\033[96m'
    BOLD = '\033[1m'
    RESET = '\033[0m'

def print_colored(text: str, color: str = Colors.RESET):
    """Imprime texto colorido."""
    print(f"{color}{text}{Colors.RESET}")

class APITester:
    """Testador de APIs com medição de performance."""

    def __init__(self, base_url: str):
        self.base_url = base_url.rstrip('/')
        self.resultados = {}
        self.total_requests = 0
        self.successful_requests = 0
        self.failed_requests = 0

        self.headers = {
            "User-Agent": "Test-API-Client/1.0",
            "Accept": "application/json"
        }

        # Endpoints para testar
        self.endpoints = [
            {
                "path": "/api/status",
                "method": "GET",
                "description": "Status do servidor"
            },
            {
                "path": "/api/pacientes/internados",
                "method": "GET",
                "description": "Pacientes internados"
            },
            {
                "path": "/api/pacientes/urgencia",
                "method": "GET",
                "description": "Pacientes em urgência"
            },
            {
                "path": "/api/pacientes/acolhimento",
                "method": "GET",
                "description": "Pacientes em acolhimento"
            },
            {
                "path": "/api/pacientes/todos",
                "method": "GET",
                "description": "Todos os pacientes"
            },
            {
                "path": "/api/especialistas",
                "method": "GET",
                "description": "Lista de especialistas"
            },
            {
                "path": "/api/especialidades",
                "method": "GET",
                "description": "Lista de especialidades"
            },
            {
                "path": "/api/slow",
                "method": "GET",
                "description": "Rota lenta (teste de timeout)"
            },
            {
                "path": "/api/error",
                "method": "GET",
                "description": "Rota com erro (teste de erro)"
            },
            {
                "path": "/api/notfound",
                "method": "GET",
                "description": "Rota inexistente (404)"
            }
        ]

    def test_endpoint(self, endpoint: Dict[str, str]) -> Dict[str, Any]:
        """Testa um endpoint específico."""
        url = self.base_url + endpoint["path"]
        method = endpoint["method"]

        inicio = time.time()

        try:
            if method == "GET":
                response = requests.get(
                    url,
                    headers=self.headers,
                    timeout=5,
                    allow_redirects=True
                )
            elif method == "POST":
                response = requests.post(
                    url,
                    headers=self.headers,
                    timeout=5,
                    allow_redirects=True
                )
            else:
                return {
                    "status": "ERROR",
                    "erro": f"Método não suportado: {method}"
                }

            tempo_ms = int((time.time() - inicio) * 1000)

            # Parse JSON
            try:
                json_data = response.json()
                tipo = "JSON"

                # Gera resumo
                if isinstance(json_data, dict):
                    if "data" in json_data and isinstance(json_data["data"], list):
                        total = len(json_data["data"])
                        resumo = f"{total} registro(s)"
                    elif "success" in json_data:
                        resumo = f"success={json_data['success']}"
                    else:
                        resumo = f"{len(json_data)} campo(s)"
                else:
                    resumo = str(json_data)[:50]

                exemplo_dados = json_data

            except json.JSONDecodeError:
                tipo = "HTML/Texto"
                texto = response.text
                resumo = f"{len(texto)} caracteres"
                exemplo_dados = texto[:200]

            resultado = {
                "status_code": response.status_code,
                "tempo_ms": tempo_ms,
                "tipo": tipo,
                "resumo": resumo,
                "descricao": endpoint["description"],
                "exemplo_dados": exemplo_dados,
                "headers": dict(response.headers)
            }

            # Atualiza contadores
            self.total_requests += 1
            if 200 <= response.status_code < 300:
                self.successful_requests += 1
            else:
                self.failed_requests += 1

            return resultado

        except requests.exceptions.Timeout:
            self.total_requests += 1
            self.failed_requests += 1
            return {
                "status_code": "TIMEOUT",
                "erro": "Timeout após 5 segundos",
                "descricao": endpoint["description"]
            }

        except requests.exceptions.ConnectionError as e:
            self.total_requests += 1
            self.failed_requests += 1
            return {
                "status_code": "CONNECTION_ERROR",
                "erro": f"Erro de conexão: {str(e)}",
                "descricao": endpoint["description"]
            }

        except Exception as e:
            self.total_requests += 1
            self.failed_requests += 1
            return {
                "status_code": "ERROR",
                "erro": str(e),
                "descricao": endpoint["description"]
            }

    def run_tests(self):
        """Executa todos os testes."""
        print_colored("=" * 80, Colors.CYAN)
        print_colored("🚀 TEST API CLIENT - INICIANDO TESTES", Colors.BOLD)
        print_colored("=" * 80, Colors.CYAN)
        print(f"📡 Base URL: {self.base_url}")
        print(f"🧪 Total de endpoints: {len(self.endpoints)}")
        print(f"🕐 Data/Hora: {datetime.now().strftime('%d/%m/%Y %H:%M:%S')}")
        print_colored("-" * 80, Colors.CYAN)
        print()

        for i, endpoint in enumerate(self.endpoints, 1):
            print(f"[{i}/{len(self.endpoints)}] Testando {endpoint['path']}...")

            resultado = self.test_endpoint(endpoint)
            self.resultados[endpoint["path"]] = resultado

            # Exibe resultado
            status = resultado.get("status_code", "ERROR")
            tempo = resultado.get("tempo_ms", 0)

            if isinstance(status, int):
                if 200 <= status < 300:
                    emoji = "✅"
                    color = Colors.GREEN
                elif 400 <= status < 500:
                    emoji = "⚠️"
                    color = Colors.YELLOW
                else:
                    emoji = "❌"
                    color = Colors.RED

                print_colored(f"{emoji} [{status}] {endpoint['path']} ({tempo}ms)", color)

                if "resumo" in resultado:
                    print(f"   └─ {resultado['resumo']}")
            else:
                print_colored(f"❌ [{status}] {endpoint['path']}", Colors.RED)
                if "erro" in resultado:
                    print(f"   └─ {resultado['erro']}")

            print()
            time.sleep(0.3)  # Pequeno delay

        print_colored("-" * 80, Colors.CYAN)
        print_colored("🏁 TESTES CONCLUÍDOS!", Colors.BOLD)
        print_colored("-" * 80, Colors.CYAN)
        print()

    def show_summary(self):
        """Exibe resumo dos testes."""
        print_colored("=" * 80, Colors.CYAN)
        print_colored("📊 RESUMO DOS TESTES", Colors.BOLD)
        print_colored("=" * 80, Colors.CYAN)
        print()

        # Estatísticas
        print(f"Total de requisições: {self.total_requests}")
        print_colored(f"✅ Sucesso: {self.successful_requests}", Colors.GREEN)
        print_colored(f"❌ Falhas: {self.failed_requests}", Colors.RED)

        if self.total_requests > 0:
            taxa_sucesso = (self.successful_requests / self.total_requests) * 100
            print(f"📈 Taxa de sucesso: {taxa_sucesso:.1f}%")

        print()

        # Tabela de resultados
        print_colored("-" * 80, Colors.CYAN)
        print(f"{'Endpoint':<40} {'Status':<15} {'Tempo':<10} {'Tipo':<10}")
        print_colored("-" * 80, Colors.CYAN)

        for path, dados in self.resultados.items():
            status = str(dados.get("status_code", "N/A"))
            tempo = f"{dados.get('tempo_ms', 0)}ms" if "tempo_ms" in dados else "N/A"
            tipo = dados.get("tipo", "N/A")

            # Trunca o path se for muito longo
            path_display = path if len(path) <= 39 else path[:36] + "..."

            print(f"{path_display:<40} {status:<15} {tempo:<10} {tipo:<10}")

        print()

    def save_report(self, filename: str = "test_results.json"):
        """Salva relatório em JSON."""
        # Remove dados muito grandes
        resultados_limpos = {}
        for path, dados in self.resultados.items():
            dados_copia = dados.copy()

            # Trunca exemplo_dados se for muito grande
            if "exemplo_dados" in dados_copia:
                exemplo = dados_copia["exemplo_dados"]
                if isinstance(exemplo, str) and len(exemplo) > 500:
                    dados_copia["exemplo_dados"] = exemplo[:500] + "... (TRUNCADO)"

            # Remove headers para reduzir tamanho
            if "headers" in dados_copia:
                del dados_copia["headers"]

            resultados_limpos[path] = dados_copia

        # Adiciona metadados
        relatorio = {
            "metadata": {
                "base_url": self.base_url,
                "timestamp": datetime.now().isoformat(),
                "total_requests": self.total_requests,
                "successful_requests": self.successful_requests,
                "failed_requests": self.failed_requests,
                "success_rate": f"{(self.successful_requests / self.total_requests * 100):.1f}%" if self.total_requests > 0 else "0%"
            },
            "results": resultados_limpos
        }

        with open(filename, "w", encoding="utf-8") as f:
            json.dump(relatorio, f, indent=2, ensure_ascii=False)

        print_colored(f"✅ Relatório salvo em: {filename}", Colors.GREEN)
        print()


def main():
    """Função principal."""

    # URL padrão
    default_url = "http://localhost:3000"

    # Verifica argumentos
    if len(sys.argv) > 1:
        base_url = sys.argv[1]
    else:
        print_colored("=" * 80, Colors.CYAN)
        print_colored("🧪 TEST API CLIENT", Colors.BOLD)
        print_colored("=" * 80, Colors.CYAN)
        print()
        print("Uso:")
        print(f"  python3 test-api-client.py [URL]")
        print()
        print("Exemplos:")
        print(f"  python3 test-api-client.py http://localhost:3000")
        print(f"  python3 test-api-client.py https://flat-paths-cheat.loca.lt")
        print()

        base_url = input(f"Digite a URL base (Enter para usar {default_url}): ").strip()

        if not base_url:
            base_url = default_url

        print()

    # Remove barra final se houver
    base_url = base_url.rstrip('/')

    # Cria tester e executa
    tester = APITester(base_url)

    try:
        tester.run_tests()
        tester.show_summary()
        tester.save_report()

        print_colored("=" * 80, Colors.CYAN)
        print_colored("✨ TESTES FINALIZADOS COM SUCESSO!", Colors.BOLD)
        print_colored("=" * 80, Colors.CYAN)

    except KeyboardInterrupt:
        print()
        print_colored("⚠️  Testes interrompidos pelo usuário", Colors.YELLOW)
        sys.exit(0)


if __name__ == "__main__":
    main()
