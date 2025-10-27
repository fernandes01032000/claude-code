/**
 * Logger Utility
 *
 * Sistema simples de logging com níveis e timestamps
 */

const fs = require('fs');
const path = require('path');

class Logger {
  constructor(options = {}) {
    this.logLevel = options.logLevel || process.env.LOG_LEVEL || 'info';
    this.logToFile = options.logToFile !== false;
    this.logDir = options.logDir || path.join(process.cwd(), 'logs');
    this.logFile = options.logFile || 'app.log';

    this.levels = {
      error: 0,
      warn: 1,
      info: 2,
      debug: 3
    };

    // Criar diretório de logs se não existir
    if (this.logToFile && !fs.existsSync(this.logDir)) {
      fs.mkdirSync(this.logDir, { recursive: true });
    }
  }

  /**
   * Formata mensagem de log
   */
  format(level, message, meta = {}) {
    const timestamp = new Date().toISOString();
    const metaStr = Object.keys(meta).length > 0 ? JSON.stringify(meta) : '';

    return `[${timestamp}] [${level.toUpperCase()}] ${message} ${metaStr}`.trim();
  }

  /**
   * Escreve log no arquivo
   */
  writeToFile(formatted) {
    if (!this.logToFile) return;

    const logPath = path.join(this.logDir, this.logFile);
    fs.appendFileSync(logPath, formatted + '\n');
  }

  /**
   * Log genérico
   */
  log(level, message, meta = {}) {
    if (this.levels[level] > this.levels[this.logLevel]) {
      return; // Não loga se nível for maior que configurado
    }

    const formatted = this.format(level, message, meta);

    // Console output com cores
    const colors = {
      error: '\x1b[31m', // Red
      warn: '\x1b[33m',  // Yellow
      info: '\x1b[36m',  // Cyan
      debug: '\x1b[90m'  // Gray
    };

    console.log(colors[level] + formatted + '\x1b[0m');

    // File output
    this.writeToFile(formatted);
  }

  /**
   * Métodos de conveniência
   */
  error(message, meta) {
    this.log('error', message, meta);
  }

  warn(message, meta) {
    this.log('warn', message, meta);
  }

  info(message, meta) {
    this.log('info', message, meta);
  }

  debug(message, meta) {
    this.log('debug', message, meta);
  }

  /**
   * Log de requisições HTTP
   */
  http(req, res, duration) {
    const message = `${req.method} ${req.path} ${res.statusCode} ${duration}ms`;
    const meta = {
      method: req.method,
      path: req.path,
      status: res.statusCode,
      duration,
      ip: req.ip
    };

    this.info(message, meta);
  }
}

// Instância padrão
const logger = new Logger();

module.exports = logger;
module.exports.Logger = Logger;
