/**
 * Environment Variables Validator
 *
 * Valida se todas as variáveis de ambiente necessárias estão configuradas
 */

class EnvValidator {
  constructor(requiredVars = []) {
    this.requiredVars = requiredVars;
    this.errors = [];
  }

  /**
   * Adiciona variável obrigatória
   */
  require(varName, options = {}) {
    this.requiredVars.push({ name: varName, ...options });
    return this;
  }

  /**
   * Valida se variável existe
   */
  validateExists(varName) {
    if (!process.env[varName]) {
      this.errors.push(`Missing required environment variable: ${varName}`);
      return false;
    }
    return true;
  }

  /**
   * Valida tipo da variável
   */
  validateType(varName, type) {
    const value = process.env[varName];

    switch (type) {
      case 'number':
        if (isNaN(Number(value))) {
          this.errors.push(`${varName} must be a number, got: ${value}`);
          return false;
        }
        break;

      case 'boolean':
        if (!['true', 'false', '1', '0'].includes(value?.toLowerCase())) {
          this.errors.push(`${varName} must be a boolean, got: ${value}`);
          return false;
        }
        break;

      case 'url':
        try {
          new URL(value);
        } catch (e) {
          this.errors.push(`${varName} must be a valid URL, got: ${value}`);
          return false;
        }
        break;

      case 'email':
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(value)) {
          this.errors.push(`${varName} must be a valid email, got: ${value}`);
          return false;
        }
        break;
    }

    return true;
  }

  /**
   * Valida enum (valores permitidos)
   */
  validateEnum(varName, allowedValues) {
    const value = process.env[varName];

    if (!allowedValues.includes(value)) {
      this.errors.push(
        `${varName} must be one of [${allowedValues.join(', ')}], got: ${value}`
      );
      return false;
    }

    return true;
  }

  /**
   * Valida todas as variáveis
   */
  validate() {
    this.errors = [];

    for (const varConfig of this.requiredVars) {
      const { name, type, enum: allowedValues } = varConfig;

      // Verifica existência
      if (!this.validateExists(name)) {
        continue;
      }

      // Valida tipo se especificado
      if (type) {
        this.validateType(name, type);
      }

      // Valida enum se especificado
      if (allowedValues) {
        this.validateEnum(name, allowedValues);
      }
    }

    if (this.errors.length > 0) {
      console.error('❌ Environment validation failed:\n');
      this.errors.forEach(error => console.error(`  - ${error}`));
      console.error('\n💡 Check your .env file and .env.example for reference');
      return false;
    }

    console.log('✅ Environment variables validated successfully');
    return true;
  }

  /**
   * Valida e lança erro se falhar
   */
  validateOrThrow() {
    if (!this.validate()) {
      throw new Error('Environment validation failed');
    }
  }

  /**
   * Mostra variáveis configuradas (sem valores sensíveis)
   */
  showConfig() {
    console.log('\n📋 Current configuration:');
    this.requiredVars.forEach(({ name }) => {
      const value = process.env[name];
      const displayValue = this.isSensitive(name)
        ? '***HIDDEN***'
        : value;
      console.log(`  ${name}: ${displayValue}`);
    });
    console.log('');
  }

  /**
   * Verifica se variável é sensível
   */
  isSensitive(varName) {
    const sensitivePatterns = [
      'PASSWORD', 'SECRET', 'KEY', 'TOKEN', 'CREDENTIAL',
      'PRIVATE', 'AUTH', 'API_KEY'
    ];

    return sensitivePatterns.some(pattern =>
      varName.toUpperCase().includes(pattern)
    );
  }
}

/**
 * Exemplo de uso
 */
function exampleUsage() {
  const validator = new EnvValidator()
    .require('DB_HOST')
    .require('DB_PORT', { type: 'number' })
    .require('DB_NAME')
    .require('DB_USER')
    .require('DB_PASSWORD')
    .require('NODE_ENV', { enum: ['development', 'staging', 'production'] })
    .require('APP_PORT', { type: 'number' })
    .require('API_URL', { type: 'url' })
    .require('SMTP_HOST')
    .require('SMTP_PORT', { type: 'number' });

  validator.validateOrThrow();
  validator.showConfig();
}

module.exports = EnvValidator;
module.exports.exampleUsage = exampleUsage;
