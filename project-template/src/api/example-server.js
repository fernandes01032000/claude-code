/**
 * Exemplo de servidor Express básico
 *
 * Para usar:
 * 1. npm install express dotenv cors helmet morgan
 * 2. Configure .env com APP_PORT=3000
 * 3. node src/api/example-server.js
 */

require('dotenv').config();
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');

const app = express();
const PORT = process.env.APP_PORT || 3000;

// =====================================
// Middleware
// =====================================
app.use(helmet()); // Segurança
app.use(cors());   // CORS
app.use(express.json()); // Parse JSON
app.use(express.urlencoded({ extended: true }));

// Logging simples
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.path}`);
  next();
});

// =====================================
// Routes
// =====================================

// Health check
app.get('/health', (req, res) => {
  res.json({
    status: 'ok',
    timestamp: new Date().toISOString(),
    uptime: process.uptime()
  });
});

// API v1
app.get('/api/v1/hello', (req, res) => {
  res.json({
    message: 'Hello World!',
    version: '1.0.0'
  });
});

// Exemplo com parâmetros
app.get('/api/v1/users/:id', (req, res) => {
  const { id } = req.params;
  res.json({
    id,
    name: 'Usuário Exemplo',
    email: 'usuario@example.com'
  });
});

// Exemplo POST
app.post('/api/v1/users', (req, res) => {
  const { name, email } = req.body;

  if (!name || !email) {
    return res.status(400).json({
      error: 'Name and email are required'
    });
  }

  res.status(201).json({
    id: Date.now(),
    name,
    email,
    created_at: new Date().toISOString()
  });
});

// =====================================
// Error Handling
// =====================================

// 404 Handler
app.use((req, res) => {
  res.status(404).json({
    error: 'Route not found',
    path: req.path
  });
});

// Error Handler
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({
    error: 'Internal server error',
    message: process.env.NODE_ENV === 'development' ? err.message : undefined
  });
});

// =====================================
// Start Server
// =====================================
app.listen(PORT, () => {
  console.log(`
╔════════════════════════════════════════╗
║   Server running on port ${PORT}        ║
║   Environment: ${process.env.NODE_ENV || 'development'}            ║
║   API: http://localhost:${PORT}/api/v1  ║
╚════════════════════════════════════════╝
  `);
});

// Graceful shutdown
process.on('SIGTERM', () => {
  console.log('SIGTERM received, shutting down gracefully');
  process.exit(0);
});
