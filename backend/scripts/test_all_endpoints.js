const http = require('http');

const PORT = 3000;
const BASE_URL = `http://localhost:${PORT}`;

const endpointsToTest = [
  { path: '/api/v1/health', method: 'GET' },
  { path: '/api/v1/admin/dashboard', method: 'GET' },
  { path: '/api/v1/admin/dashboard/summary', method: 'GET' },
  { path: '/api/v1/admin/shops', method: 'GET' },
  { path: '/api/v1/admin/accounts', method: 'GET' },
  { path: '/api/v1/admin/businesses', method: 'GET' },
  { path: '/api/v1/admin/companies', method: 'GET' },
  { path: '/api/v1/admin/plans', method: 'GET' },
  { path: '/api/v1/admin/subscriptions', method: 'GET' },
  { path: '/api/v1/admin/purchases', method: 'GET' },
  { path: '/api/v1/admin/payments', method: 'GET' },
  { path: '/api/v1/plans', method: 'GET' },
];

function testEndpoint(endpoint) {
  return new Promise((resolve) => {
    const url = `${BASE_URL}${endpoint.path}`;
    http
      .get(url, (res) => {
        let body = '';
        res.on('data', (chunk) => (body += chunk));
        res.on('end', () => {
          try {
            const json = JSON.parse(body);
            const isOk = res.statusCode >= 200 && res.statusCode < 300 && json.success !== false;
            console.log(
              `${isOk ? '✅' : '❌'} [${res.statusCode}] ${endpoint.method} ${endpoint.path} - ${
                json.message || 'OK'
              }`
            );
            resolve({ path: endpoint.path, status: res.statusCode, isOk, data: json });
          } catch (err) {
            console.log(`❌ [${res.statusCode}] ${endpoint.method} ${endpoint.path} - Invalid JSON`);
            resolve({ path: endpoint.path, status: res.statusCode, isOk: false, error: err });
          }
        });
      })
      .on('error', (err) => {
        console.log(`❌ [ERROR] ${endpoint.method} ${endpoint.path} - ${err.message}`);
        resolve({ path: endpoint.path, status: 0, isOk: false, error: err });
      });
  });
}

async function runTests() {
  console.log('🚀 Starting API Endpoints Verification Suite...');
  console.log('==================================================');

  let passed = 0;
  let failed = 0;

  for (const endpoint of endpointsToTest) {
    const result = await testEndpoint(endpoint);
    if (result.isOk) {
      passed++;
    } else {
      failed++;
    }
  }

  console.log('==================================================');
  console.log(`📊 Summary: ${passed} Passed, ${failed} Failed out of ${endpointsToTest.length} Endpoints.`);

  if (failed > 0) {
    process.exit(1);
  } else {
    process.exit(0);
  }
}

runTests();
