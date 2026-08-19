const { pool } = require('../src/db/database');

async function cleanDemoData() {
  try {
    console.log('🧹 Cleaning demo data from PostgreSQL database...');
    
    await pool.query('TRUNCATE TABLE payments, subscriptions, shops CASCADE;');

    console.log('✅ Demo shops, subscriptions, and payments successfully removed!');

    const shopsRes = await pool.query('SELECT COUNT(*) as count FROM shops');
    console.log(`Shops remaining: ${shopsRes.rows[0].count}`);

    const plansRes = await pool.query('SELECT id, name FROM plans');
    console.log('Standard plans active in database:', plansRes.rows);

    process.exit(0);
  } catch (err) {
    console.error('❌ Error cleaning database:', err);
    process.exit(1);
  }
}

cleanDemoData();
