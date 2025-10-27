#!/usr/bin/env node
/**
 * Test Server - Servidor de testes para simular APIs
 * Uso: node test-server.js
 */

const http = require('http');
const url = require('url');

const PORT = 3000;

// Simula dados de exemplo
const mockData = {
    pacientes: [
        { id: 1, nome: "João Silva", idade: 45, status: "Internado" },
        { id: 2, nome: "Maria Santos", idade: 32, status: "Em atendimento" },
        { id: 3, nome: "Pedro Costa", idade: 67, status: "Acolhimento" }
    ],
    especialistas: [
        { id: 1, nome: "Dr. Carlos", especialidade: "Cardiologia" },
        { id: 2, nome: "Dra. Ana", especialidade: "Neurologia" },
        { id: 3, nome: "Dr. Paulo", especialidade: "Ortopedia" }
    ],
    especialidades: [
        { id: 1, nome: "Cardiologia", disponivel: true },
        { id: 2, nome: "Neurologia", disponivel: true },
        { id: 3, nome: "Ortopedia", disponivel: false }
    ]
};

// Rotas da API
const routes = {
    '/api/pacientes/internados': (req, res) => {
        setTimeout(() => {
            res.writeHead(200, { 'Content-Type': 'application/json' });
            res.end(JSON.stringify({
                success: true,
                data: mockData.pacientes.filter(p => p.status === "Internado"),
                total: 1
            }));
        }, Math.random() * 200); // Simula latência variável
    },

    '/api/pacientes/urgencia': (req, res) => {
        setTimeout(() => {
            res.writeHead(200, { 'Content-Type': 'application/json' });
            res.end(JSON.stringify({
                success: true,
                data: mockData.pacientes.filter(p => p.status === "Em atendimento"),
                total: 1
            }));
        }, Math.random() * 200);
    },

    '/api/pacientes/acolhimento': (req, res) => {
        setTimeout(() => {
            res.writeHead(200, { 'Content-Type': 'application/json' });
            res.end(JSON.stringify({
                success: true,
                data: mockData.pacientes.filter(p => p.status === "Acolhimento"),
                total: 1
            }));
        }, Math.random() * 200);
    },

    '/api/pacientes/todos': (req, res) => {
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({
            success: true,
            data: mockData.pacientes,
            total: mockData.pacientes.length
        }));
    },

    '/api/especialistas': (req, res) => {
        setTimeout(() => {
            res.writeHead(200, { 'Content-Type': 'application/json' });
            res.end(JSON.stringify({
                success: true,
                data: mockData.especialistas,
                total: mockData.especialistas.length
            }));
        }, Math.random() * 300);
    },

    '/api/especialidades': (req, res) => {
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({
            success: true,
            data: mockData.especialidades,
            total: mockData.especialidades.length
        }));
    },

    '/api/status': (req, res) => {
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({
            success: true,
            status: "online",
            timestamp: new Date().toISOString(),
            version: "1.0.0"
        }));
    },

    '/api/slow': (req, res) => {
        // Rota lenta para testar timeouts
        setTimeout(() => {
            res.writeHead(200, { 'Content-Type': 'application/json' });
            res.end(JSON.stringify({
                success: true,
                message: "Esta rota demora 2 segundos"
            }));
        }, 2000);
    },

    '/api/error': (req, res) => {
        // Rota que sempre retorna erro
        res.writeHead(500, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({
            success: false,
            error: "Erro simulado para testes"
        }));
    },

    '/api/notfound': (req, res) => {
        res.writeHead(404, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({
            success: false,
            error: "Recurso não encontrado"
        }));
    },

    '/': (req, res) => {
        res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
        res.end(`
<!DOCTYPE html>
<html>
<head>
    <title>Test API Server</title>
    <style>
        body { font-family: Arial, sans-serif; max-width: 800px; margin: 50px auto; padding: 20px; }
        h1 { color: #333; }
        .endpoint { background: #f4f4f4; padding: 15px; margin: 10px 0; border-radius: 5px; }
        .method { color: #0066cc; font-weight: bold; }
        code { background: #e8e8e8; padding: 2px 5px; border-radius: 3px; }
        a { color: #0066cc; text-decoration: none; }
        a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <h1>🚀 Test API Server</h1>
    <p>Servidor de testes rodando na porta ${PORT}</p>

    <h2>📋 Endpoints Disponíveis:</h2>

    <div class="endpoint">
        <span class="method">GET</span> <code>/api/pacientes/internados</code>
        <p>Retorna pacientes internados</p>
        <a href="/api/pacientes/internados" target="_blank">→ Testar</a>
    </div>

    <div class="endpoint">
        <span class="method">GET</span> <code>/api/pacientes/urgencia</code>
        <p>Retorna pacientes em atendimento de urgência</p>
        <a href="/api/pacientes/urgencia" target="_blank">→ Testar</a>
    </div>

    <div class="endpoint">
        <span class="method">GET</span> <code>/api/pacientes/acolhimento</code>
        <p>Retorna pacientes em acolhimento</p>
        <a href="/api/pacientes/acolhimento" target="_blank">→ Testar</a>
    </div>

    <div class="endpoint">
        <span class="method">GET</span> <code>/api/pacientes/todos</code>
        <p>Retorna todos os pacientes</p>
        <a href="/api/pacientes/todos" target="_blank">→ Testar</a>
    </div>

    <div class="endpoint">
        <span class="method">GET</span> <code>/api/especialistas</code>
        <p>Retorna lista de especialistas</p>
        <a href="/api/especialistas" target="_blank">→ Testar</a>
    </div>

    <div class="endpoint">
        <span class="method">GET</span> <code>/api/especialidades</code>
        <p>Retorna lista de especialidades</p>
        <a href="/api/especialidades" target="_blank">→ Testar</a>
    </div>

    <div class="endpoint">
        <span class="method">GET</span> <code>/api/status</code>
        <p>Status do servidor</p>
        <a href="/api/status" target="_blank">→ Testar</a>
    </div>

    <div class="endpoint">
        <span class="method">GET</span> <code>/api/slow</code>
        <p>Rota lenta (2s) para testar timeouts</p>
        <a href="/api/slow" target="_blank">→ Testar</a>
    </div>

    <div class="endpoint">
        <span class="method">GET</span> <code>/api/error</code>
        <p>Retorna erro 500 (para testes)</p>
        <a href="/api/error" target="_blank">→ Testar</a>
    </div>

    <h2>🧪 Como testar:</h2>
    <pre>curl http://localhost:${PORT}/api/status</pre>
    <pre>python3 test-api-client.py</pre>
</body>
</html>
        `);
    }
};

// Servidor HTTP
const server = http.createServer((req, res) => {
    // CORS headers
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

    // Handle OPTIONS
    if (req.method === 'OPTIONS') {
        res.writeHead(200);
        res.end();
        return;
    }

    const parsedUrl = url.parse(req.url, true);
    const pathname = parsedUrl.pathname;

    console.log(`[${new Date().toISOString()}] ${req.method} ${pathname}`);

    // Rota handler
    const handler = routes[pathname];

    if (handler) {
        handler(req, res);
    } else {
        res.writeHead(404, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({
            success: false,
            error: `Rota não encontrada: ${pathname}`,
            availableRoutes: Object.keys(routes)
        }));
    }
});

server.listen(PORT, () => {
    console.log('========================================');
    console.log('✅ Servidor rodando em http://localhost:' + PORT);
    console.log('========================================');
    console.log('📋 Endpoints disponíveis:');
    Object.keys(routes).forEach(route => {
        console.log(`   - http://localhost:${PORT}${route}`);
    });
    console.log('========================================');
    console.log('💡 Pressione Ctrl+C para parar');
    console.log('========================================');
});
