const http = require('http');
const { pool, adminQuery } = require('../src/db/database');

console.log('🧪 Running Dedicated Admin Authentication Verification Suite...');
console.log('==================================================');

function makeRequest(path, method = 'GET', body = null, token = null) {
  return new Promise((resolve, reject) => {
    const headers = { 'Content-Type': 'application/json' };
    if (token) headers['Authorization'] = `Bearer ${token}`;

    const options = {
      hostname: '127.0.0.1',
      port: process.env.PORT || 3000,
      path: `/api/v1${path}`,
      method,
      headers,
    };

    const req = http.request(options, (res) => {
      let data = '';
      res.on('data', (chunk) => (data += chunk));
      res.on('end', () => {
        try {
          const parsed = JSON.parse(data);
          resolve({ status: res.statusCode, body: parsed });
        } catch (_) {
          resolve({ status: res.statusCode, body: data });
        }
      });
    });

    req.on('error', (err) => reject(err));

    if (body) {
      req.write(JSON.stringify(body));
    }
    req.end();
  });
}

async function runTests() {
  let passed = 0;
  let failed = 0;

  function assert(condition, message) {
    if (condition) {
      console.log(`✅ [PASS] ${message}`);
      passed++;
    } else {
      console.error(`❌ [FAIL] ${message}`);
      failed++;
    }
  }

  try {
    // 1. Verify Password Hash & Database Isolation in PostgreSQL
    const adminRows = await adminQuery("SELECT * FROM admins WHERE login_id = 'admin' OR email = 'admin@xenobiz.local';");
    const adminRecord = adminRows.rows[0];

    assert(!!adminRecord, 'Admin record exists in dedicated admins table');
    if (adminRecord) {
      assert(
        adminRecord.password_hash.startsWith('$2a$') || adminRecord.password_hash.startsWith('$2b$'),
        'Admin password is stored securely as a bcrypt hash (starts with $2a$ or $2b$)'
      );
      assert(
        !adminRecord.password_hash.includes('admin') && adminRecord.password_hash !== 'admin',
        'Admin password is not stored in plain text'
      );
    }

    const shopAdminRows = await pool.query("SELECT * FROM shops WHERE role = 'ADMIN' OR login_id = 'admin';");
    assert(
      shopAdminRows.rows.length === 0,
      'No admin credentials exist in shops table (shops table is isolated)'
    );

    // 2. Admin Login with Valid Credentials via /admin/login
    const validLogin = await makeRequest('/admin/login', 'POST', {
      identifier: 'admin',
      password: 'admin',
    });

    assert(
      validLogin.status === 200 && validLogin.body.success === true,
      'Admin login with valid credentials succeeds (POST /admin/login)'
    );
    const adminToken = validLogin.body?.data?.token;
    assert(!!adminToken, 'Admin login returns valid JWT token');

    // 3. Admin Login with Invalid Password
    const invalidPasswordLogin = await makeRequest('/admin/login', 'POST', {
      identifier: 'admin',
      password: 'wrong_password_123',
    });

    assert(
      invalidPasswordLogin.status === 401 && invalidPasswordLogin.body.success === false,
      'Admin login with incorrect password fails with HTTP 401'
    );

    // 4. Admin Login with Unknown Username / Email
    const unknownAdminLogin = await makeRequest('/admin/login', 'POST', {
      identifier: 'nonexistent_admin@xenobiz.local',
      password: 'admin',
    });

    assert(
      (unknownAdminLogin.status === 404 || unknownAdminLogin.status === 401) && unknownAdminLogin.body.success === false,
      'Admin login with non-existent username/email fails appropriately'
    );

    // 5. Admin Authentication Middleware Check (/auth/me)
    if (adminToken) {
      const meRes = await makeRequest('/auth/me', 'GET', null, adminToken);
      assert(
        meRes.status === 200 && meRes.body.success === true,
        'Admin JWT token is valid for authenticated endpoints (GET /auth/me)'
      );
      assert(
        meRes.body?.data?.user?.role === 'ADMIN',
        'Admin JWT token correctly resolves admin identity from admins table'
      );
    }

    // 6. Shop Account Login Sanity Check
    const shopLogin = await makeRequest('/auth/login', 'POST', {
      identifier: 'demo@xenobiz.local',
      password: 'Demo@12345',
    });

    assert(
      shopLogin.status === 200 && shopLogin.body.success === true,
      'Shop account login continues working normally (POST /auth/login)'
    );
    assert(
      shopLogin.body?.data?.shop?.id === 'shop_novatech',
      'Shop data is correctly fetched from shops table'
    );

    console.log('==================================================');
    console.log(`📊 Test Summary: ${passed} Passed, ${failed} Failed out of ${passed + failed} Tests.`);

    if (failed > 0) {
      process.exit(1);
    } else {
      process.exit(0);
    }
  } catch (err) {
    console.error('❌ Test suite execution error:', err);
    process.exit(1);
  }
}

runTests();
