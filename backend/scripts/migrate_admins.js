const bcrypt = require('bcryptjs');
const { v4: uuidv4 } = require('uuid');
const env = require('../src/config/env');
const { pool, initDb } = require('../src/db/database');
const adminRepository = require('../src/repositories/admin_repository');

async function migrateAdmins() {
  console.log('🔄 Starting Admin Database Migration...');
  await initDb();

  // 1. Check for legacy admin records in the shops table
  const legacyAdminsRes = await pool.query(`
    SELECT * FROM shops 
    WHERE role = 'ADMIN' OR LOWER(login_id) = 'admin' OR LOWER(email) LIKE '%admin%';
  `);

  const legacyAdmins = legacyAdminsRes.rows;
  console.log(`Found ${legacyAdmins.length} legacy admin record(s) in shops table.`);

  for (const legacy of legacyAdmins) {
    console.log(`Migrating legacy admin: ${legacy.email} (${legacy.login_id})...`);

    let passwordHash = legacy.password_hash;
    // Ensure password is bcrypt hashed
    if (!passwordHash || !passwordHash.startsWith('$2a$')) {
      const plainPassword = passwordHash || env.ADMIN_INITIAL_PASSWORD || 'admin';
      const salt = await bcrypt.genSalt(10);
      passwordHash = await bcrypt.hash(plainPassword, salt);
    }

    const existingAdmin = await adminRepository.findByEmailOrLoginId(legacy.email || legacy.login_id);
    if (!existingAdmin) {
      await adminRepository.create({
        id: legacy.id === 'shop_admin' ? `admin_${uuidv4().substring(0, 8)}` : legacy.id,
        name: legacy.owner_name || legacy.shop_name || 'System Administrator',
        email: legacy.email,
        loginId: legacy.login_id || 'admin',
        passwordHash,
        status: legacy.status || 'active',
        role: legacy.role || 'ADMIN',
      });
      console.log(`✅ Admin ${legacy.email} successfully inserted into dedicated admins table.`);
    } else {
      console.log(`ℹ️ Admin ${legacy.email} already exists in dedicated admins table.`);
    }

    // Remove legacy admin from shops table
    await pool.query('DELETE FROM shops WHERE id = $1', [legacy.id]);
    console.log(`🧹 Legacy admin record ${legacy.id} removed from shops table.`);
  }

  // 2. Ensure at least one system admin account exists in admins table
  const allAdmins = await adminRepository.findAll();
  if (allAdmins.length === 0) {
    console.log('No admin accounts found. Creating default system admin account...');
    const defaultEmail = env.ADMIN_INITIAL_EMAIL || 'admin@xenobiz.local';
    const defaultPassword = env.ADMIN_INITIAL_PASSWORD || 'admin';
    const salt = await bcrypt.genSalt(10);
    const passwordHash = await bcrypt.hash(defaultPassword, salt);

    await adminRepository.create({
      id: `admin_${uuidv4().substring(0, 8)}`,
      name: 'System Administrator',
      email: defaultEmail,
      loginId: 'admin',
      passwordHash,
      status: 'active',
      role: 'ADMIN',
    });
    console.log(`✅ Default admin account created: ${defaultEmail} / login_id: admin`);
  }

  console.log('==================================================');
  console.log('🎉 Admin Database Migration Completed Successfully!');
  console.log('==================================================');
}

migrateAdmins()
  .then(() => process.exit(0))
  .catch((err) => {
    console.error('❌ Admin Migration Failed:', err);
    process.exit(1);
  });
