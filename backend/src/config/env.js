require('dotenv').config();

module.exports = {
  PORT: process.env.PORT || 3000,
  DATABASE_URL: process.env.DATABASE_URL,
  ADMIN_DATABASE_URL: process.env.ADMIN_DATABASE_URL || process.env.DATABASE_URL,
  NODE_ENV: process.env.NODE_ENV || 'development',
  JWT_SECRET: process.env.JWT_SECRET,
  ADMIN_INITIAL_EMAIL: process.env.ADMIN_INITIAL_EMAIL || 'admin@xenobiz.local',
  ADMIN_INITIAL_PASSWORD: process.env.ADMIN_INITIAL_PASSWORD || 'admin',
};