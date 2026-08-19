const { initDb } = require('../src/db/database');

async function run() {
  console.log('Running database migrations...');
  try {
    await initDb();
    console.log('✅ Database schema migration completed successfully!');
    
    // Execute admin migration step
    require('./migrate_admins');
  } catch (error) {
    console.error('❌ Database migration failed:', error);
    process.exit(1);
  }
}

run();
