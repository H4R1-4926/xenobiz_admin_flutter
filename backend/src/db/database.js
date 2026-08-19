const { Pool } = require('pg');
const fs = require('fs');
const path = require('path');
const env = require('../config/env');

// const pool = new Pool({
//   connectionString: env.DATABASE_URL,
//   ssl: false,
// });

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: process.env.NODE_ENV === "production"
    ? { rejectUnauthorized: false }
    : false
});

pool.on('connect', () => {
  console.log('PostgreSQL shop database connected');
});

pool.on('error', (error) => {
  console.error('Unexpected PostgreSQL shop database error:', error);
});

// Admin Database connection pool
const adminPool = (env.ADMIN_DATABASE_URL && env.ADMIN_DATABASE_URL !== env.DATABASE_URL)
  ? new Pool({
      connectionString: env.ADMIN_DATABASE_URL,
      ssl: false,
    })
  : pool;

if (adminPool !== pool) {
  adminPool.on('connect', () => {
    console.log('PostgreSQL dedicated admin database connected');
  });

  adminPool.on('error', (error) => {
    console.error('Unexpected PostgreSQL admin database error:', error);
  });
}

async function adminQuery(text, params) {
  return await adminPool.query(text, params);
}

async function initDb() {
  try {
    const schemaPath = path.join(__dirname, 'schema.sql');
    const schemaSql = fs.readFileSync(schemaPath, 'utf8');

    await pool.query(schemaSql);

    if (adminPool !== pool) {
      await adminPool.query(schemaSql);
    }

    console.log('PostgreSQL database initialized successfully');
  } catch (error) {
    console.error('PostgreSQL database initialization failed:');
    console.error(error);

    throw error;
  }
}

module.exports = {
  pool,
  adminPool,
  adminQuery,
  initDb,
};