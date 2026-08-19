const bcrypt = require('bcryptjs');
const env = require('../src/config/env');
const { pool, adminQuery, initDb } = require('../src/db/database');
const adminRepository = require('../src/repositories/admin_repository');
const shopRepository = require('../src/repositories/shop_repository');
const planRepository = require('../src/repositories/plan_repository');
const subscriptionRepository = require('../src/repositories/subscription_repository');
const billingPaymentRepository = require('../src/repositories/billing_payment_repository');

console.log('🌱 Seeding XenoBiz PostgreSQL database...');

async function seed() {
  await initDb();

  // Clear existing records safely
  await pool.query(`
    TRUNCATE TABLE payments, subscriptions, plans, shops CASCADE;
  `);
  await adminQuery(`
    TRUNCATE TABLE admins CASCADE;
  `);

  const passwordHash = await bcrypt.hash('Demo@12345', 10);
  const initialAdminPass = env.ADMIN_INITIAL_PASSWORD || 'admin';
  const adminHash = await bcrypt.hash(initialAdminPass, 10);

  // 1. Seed Subscription Plans
  const planFree = await planRepository.create({
    id: 'plan_free',
    name: 'Free',
    description: 'Essential starter plan with basic invoicing and inventory tracking.',
    price: 0.0,
    currency: 'INR',
    billingCycle: 'monthly',
    features: ['Basic Invoicing', 'Up to 50 Products', 'Single User Access', '14-Day Free Access'],
    isActive: true,
  });

  const planBasic = await planRepository.create({
    id: 'plan_basic',
    name: 'Basic',
    description: 'Standard plan for growing retail shops and small businesses.',
    price: 499.0,
    currency: 'INR',
    billingCycle: 'monthly',
    features: ['Unlimited Invoices', 'Unlimited Products', 'Customer Due Tracking', 'WhatsApp Sharing'],
    isActive: true,
  });

  const planPro = await planRepository.create({
    id: 'plan_pro',
    name: 'Pro',
    description: 'Professional suite with advanced analytics, multi-user, and CRM.',
    price: 999.0,
    currency: 'INR',
    billingCycle: 'monthly',
    features: ['All Basic Features', 'Advanced POS Reports', 'Tax/GST Export', 'Priority Support'],
    isActive: true,
  });

  const planPremium = await planRepository.create({
    id: 'plan_premium',
    name: 'Premium',
    description: 'Enterprise solution for multi-outlet businesses and franchises.',
    price: 2499.0,
    currency: 'INR',
    billingCycle: 'yearly',
    features: ['All Pro Features', 'Multi-Store Sync', 'Custom Domain', 'Dedicated Account Manager'],
    isActive: true,
  });

  console.log('✅ Created 4 Subscription Plans');

  // 2. Create System Admin Account in Dedicated Admins Table
  const adminAccount = await adminRepository.create({
    id: 'admin_sys_master',
    name: 'System Administrator',
    email: env.ADMIN_INITIAL_EMAIL || 'admin@xenobiz.local',
    loginId: 'admin',
    passwordHash: adminHash,
    role: 'ADMIN',
    status: 'active',
  });
  console.log(`✅ Created System Administrator Account in dedicated admins table (${adminAccount.login_id} / ${adminAccount.email})`);

  // 3. Shop 1: NovaTech Electronics
  const shop1 = await shopRepository.create({
    id: 'shop_novatech',
    shopName: 'NovaTech Electronics',
    ownerName: 'Rahul Sharma',
    email: 'demo@xenobiz.local',
    phone: '+91 98470 11223',
    address: 'Suite 402, Tech Park, MG Road',
    city: 'Kochi',
    state: 'Kerala',
    country: 'India',
    postalCode: '682016',
    gstNumber: '32AAACN1234F1Z5',
    businessType: 'Electronics & Gadgets',
    loginId: 'novatech_owner',
    passwordHash,
    status: 'active',
    role: 'OWNER',
  });

  // Shop 2: GreenLeaf Supermarket
  const shop2 = await shopRepository.create({
    id: 'shop_greenleaf',
    shopName: 'GreenLeaf Supermarket',
    ownerName: 'Anita Roy',
    email: 'greenleaf@xenobiz.local',
    phone: '+91 98765 43210',
    address: 'Plot 12, Main Market Road',
    city: 'Bengaluru',
    state: 'Karnataka',
    country: 'India',
    postalCode: '560001',
    gstNumber: '29ABCDE5678G1Z2',
    businessType: 'Retail / Grocery',
    loginId: 'greenleaf_owner',
    passwordHash,
    status: 'active',
    role: 'OWNER',
  });

  // Shop 3: UrbanCraft Furniture
  const shop3 = await shopRepository.create({
    id: 'shop_urbancraft',
    shopName: 'UrbanCraft Furniture',
    ownerName: 'Vikram Mehta',
    email: 'urbancraft@xenobiz.local',
    phone: '+91 99887 76655',
    address: '88 Industrial Area Phase 2',
    city: 'Mumbai',
    state: 'Maharashtra',
    country: 'India',
    postalCode: '400013',
    gstNumber: '27XYZAB9876H1Z9',
    businessType: 'Furniture & Interiors',
    loginId: 'urbancraft_owner',
    passwordHash,
    status: 'inactive',
    role: 'OWNER',
  });

  // Shop 4: Test Merchant
  const shop4 = await shopRepository.create({
    id: 'shop_6126b8ba',
    shopName: 'Test Merchant',
    ownerName: 'Test Merchant',
    email: 'testmerchant@xenobiz.local',
    phone: '+91 90000 11111',
    loginId: 'testmerchant',
    passwordHash,
    status: 'active',
    role: 'OWNER',
  });

  // Shop 5: Phone Merchant
  const shop5 = await shopRepository.create({
    id: 'shop_a1c997ce',
    shopName: 'Phone Merchant',
    ownerName: 'Phone Merchant',
    email: '9876543210@xenobiz.local',
    phone: '9876543210',
    loginId: 'phonemerchant',
    passwordHash,
    status: 'active',
    role: 'OWNER',
  });

  // Shop 6: Hari Merchant
  const shop6 = await shopRepository.create({
    id: 'shop_a543d383',
    shopName: 'hari',
    ownerName: 'hari',
    email: 'hari@gmail.com',
    phone: '+91 91234 56789',
    loginId: 'hari',
    passwordHash,
    status: 'active',
    role: 'OWNER',
  });

  console.log('✅ Created Registered Shop Accounts (All 6 Shops + Admin)');

  // 4. Seed Subscriptions & Billing Payment History
  const now = new Date();
  const thirtyDaysLater = new Date(now.getTime() + 30 * 24 * 60 * 60 * 1000);

  // NovaTech Electronics -> Pro Plan (Paid)
  const sub1 = await subscriptionRepository.create({
    id: 'sub_novatech_pro',
    shopId: shop1.id,
    planId: 'plan_pro',
    planName: 'Pro',
    status: 'active',
    startDate: new Date(now.getTime() - 60 * 24 * 60 * 60 * 1000).toISOString(),
    endDate: thirtyDaysLater.toISOString(),
    renewalDate: thirtyDaysLater.toISOString(),
    billingCycle: 'monthly',
    amount: 999.0,
    currency: 'INR',
    autoRenew: true,
    provider: 'razorpay',
  });

  // Payments for NovaTech
  await billingPaymentRepository.create({
    id: 'pay_nova_1',
    shopId: shop1.id,
    subscriptionId: sub1.id,
    planId: 'plan_pro',
    amount: 999.0,
    currency: 'INR',
    paymentMethod: 'UPI',
    provider: 'razorpay',
    transactionId: 'TXN_NOVA_AUG2026',
    status: 'successful',
    paidAt: new Date(now.getTime() - 1 * 24 * 60 * 60 * 1000).toISOString(),
  });

  await billingPaymentRepository.create({
    id: 'pay_nova_2',
    shopId: shop1.id,
    subscriptionId: sub1.id,
    planId: 'plan_pro',
    amount: 999.0,
    currency: 'INR',
    paymentMethod: 'UPI',
    provider: 'razorpay',
    transactionId: 'TXN_NOVA_JUL2026',
    status: 'successful',
    paidAt: new Date(now.getTime() - 31 * 24 * 60 * 60 * 1000).toISOString(),
  });

  // GreenLeaf Supermarket -> Basic Plan (Paid)
  const sub2 = await subscriptionRepository.create({
    id: 'sub_greenleaf_basic',
    shopId: shop2.id,
    planId: 'plan_basic',
    planName: 'Basic',
    status: 'active',
    startDate: new Date(now.getTime() - 30 * 24 * 60 * 60 * 1000).toISOString(),
    endDate: thirtyDaysLater.toISOString(),
    renewalDate: thirtyDaysLater.toISOString(),
    billingCycle: 'monthly',
    amount: 499.0,
    currency: 'INR',
    autoRenew: true,
    provider: 'razorpay',
  });

  await billingPaymentRepository.create({
    id: 'pay_green_1',
    shopId: shop2.id,
    subscriptionId: sub2.id,
    planId: 'plan_basic',
    amount: 499.0,
    currency: 'INR',
    paymentMethod: 'Card',
    provider: 'razorpay',
    transactionId: 'TXN_GREEN_AUG2026',
    status: 'successful',
    paidAt: new Date(now.getTime() - 10 * 24 * 60 * 60 * 1000).toISOString(),
  });

  // UrbanCraft Furniture -> Free Trial
  await subscriptionRepository.create({
    id: 'sub_urbancraft_free',
    shopId: shop3.id,
    planId: 'plan_free',
    planName: 'Free',
    status: 'trial',
    startDate: now.toISOString(),
    endDate: new Date(now.getTime() + 14 * 24 * 60 * 60 * 1000).toISOString(),
    renewalDate: new Date(now.getTime() + 14 * 24 * 60 * 60 * 1000).toISOString(),
    billingCycle: 'monthly',
    amount: 0.0,
    currency: 'INR',
    autoRenew: true,
    provider: 'system',
  });

  console.log('✅ Created Active Subscriptions & Billing Payment History');

  // 5. Seed Additional Admin Roles
  const supportHash = await bcrypt.hash('support123', 10);
  const readOnlyHash = await bcrypt.hash('readonly123', 10);

  await adminRepository.create({
    id: 'admin_support_01',
    name: 'Support Representative',
    email: 'support@xenobiz.local',
    loginId: 'support_admin',
    passwordHash: supportHash,
    role: 'SUPPORT_ADMIN',
    status: 'active',
  });

  await adminRepository.create({
    id: 'admin_auditor_01',
    name: 'Audit Inspector',
    email: 'auditor@xenobiz.local',
    loginId: 'readonly_admin',
    passwordHash: readOnlyHash,
    role: 'READ_ONLY',
    status: 'active',
  });

  // 6. Seed Customers
  const customerRepository = require('../src/repositories/customer_repository');
  await customerRepository.create({
    id: 'cust_01',
    shopId: shop1.id,
    name: 'Anand Varma',
    email: 'anand.varma@gmail.com',
    phone: '+91 98471 22334',
    city: 'Kochi',
    state: 'Kerala',
    country: 'India',
    status: 'active',
    totalSpent: 12500.0,
    totalPurchases: 4,
  });

  await customerRepository.create({
    id: 'cust_02',
    shopId: shop1.id,
    name: 'Priya Nambiar',
    email: 'priya.nambiar@yahoo.com',
    phone: '+91 98472 33445',
    city: 'Kochi',
    state: 'Kerala',
    country: 'India',
    status: 'active',
    totalSpent: 4500.0,
    totalPurchases: 2,
  });

  await customerRepository.create({
    id: 'cust_03',
    shopId: shop2.id,
    name: 'Suresh Kumar',
    email: 'suresh.k@gmail.com',
    phone: '+91 98761 11223',
    city: 'Bengaluru',
    state: 'Karnataka',
    country: 'India',
    status: 'active',
    totalSpent: 8900.0,
    totalPurchases: 6,
  });

  await customerRepository.create({
    id: 'cust_04',
    shopId: shop3.id,
    name: 'Kavita Menon',
    email: 'kavita.m@gmail.com',
    phone: '+91 99881 22334',
    city: 'Mumbai',
    state: 'Maharashtra',
    country: 'India',
    status: 'active',
    totalSpent: 35000.0,
    totalPurchases: 1,
  });

  console.log('✅ Created Demo Customers');

  // 7. Seed App Configuration
  const configRepository = require('../src/repositories/config_repository');
  await configRepository.upsert({
    id: 'cfg_gen_app',
    category: 'general',
    key: 'app_name',
    value: 'XenoBiz Business Manager',
    description: 'Platform branding name',
  });
  await configRepository.upsert({
    id: 'cfg_gen_ver',
    category: 'general',
    key: 'min_app_version',
    value: '1.2.0',
    description: 'Minimum required client app version',
  });
  await configRepository.upsert({
    id: 'cfg_reg_status',
    category: 'registration',
    key: 'allow_new_registrations',
    value: true,
    description: 'Allow new shop registrations',
  });
  await configRepository.upsert({
    id: 'cfg_sub_trial',
    category: 'subscription',
    key: 'default_trial_days',
    value: 14,
    description: 'Default free trial duration in days',
  });
  await configRepository.upsert({
    id: 'cfg_sys_maint',
    category: 'system',
    key: 'maintenance_mode',
    value: false,
    description: 'Global platform maintenance mode',
  });

  console.log('✅ Created Default App Configurations');

  // 8. Seed Feature Flags
  const featureFlagRepository = require('../src/repositories/feature_flag_repository');
  await featureFlagRepository.upsert({
    id: 'flag_sync',
    key: 'online_sync',
    name: 'Online Real-time Sync',
    description: 'Enable automatic WebSocket & background data sync for shops',
    isEnabled: true,
    environment: 'production',
  });
  await featureFlagRepository.upsert({
    id: 'flag_new_inv',
    key: 'new_invoice_ui',
    name: 'New POS Invoice Interface v2',
    description: 'Redesigned billing and invoice printing interface',
    isEnabled: true,
    environment: 'production',
  });
  await featureFlagRepository.upsert({
    id: 'flag_ai',
    key: 'ai_insights',
    name: 'AI Business Insights',
    description: 'Smart sales forecasting & inventory recommendations',
    isEnabled: false,
    environment: 'beta',
  });
  await featureFlagRepository.upsert({
    id: 'flag_exp',
    key: 'experimental_pos',
    name: 'Experimental Offline POS Engine',
    description: 'Local SQLite offline caching for high-volume cashiers',
    isEnabled: false,
    environment: 'development',
  });

  console.log('✅ Created Platform Feature Flags');

  // 9. Seed Initial Audit Logs
  const auditLogRepository = require('../src/repositories/audit_log_repository');
  await auditLogRepository.create({
    id: 'log_seed_01',
    adminId: 'admin_sys_master',
    adminName: 'System Administrator',
    action: 'ADMIN_LOGIN',
    targetType: 'AUTH',
    targetId: 'admin_sys_master',
    details: { message: 'Initial system admin authentication' },
    ipAddress: '127.0.0.1',
  });
  await auditLogRepository.create({
    id: 'log_seed_02',
    adminId: 'admin_sys_master',
    adminName: 'System Administrator',
    action: 'SYSTEM_INITIALIZED',
    targetType: 'SYSTEM',
    targetId: 'xenobiz_db',
    details: { message: 'Seeded initial platform schema and master configurations' },
    ipAddress: '127.0.0.1',
  });

  console.log('✅ Created Initial Platform Audit Logs');

  console.log('✅ Seeding completed successfully!');
  console.log('--------------------------------------------------');
  console.log('Development Credentials Ready:');
  console.log('1) Shop 1 (Electronics): demo@xenobiz.local / Demo@12345');
  console.log('2) Shop 2 (Grocery):     greenleaf@xenobiz.local / Demo@12345');
  console.log('3) Shop 3 (Furniture):   urbancraft@xenobiz.local / Demo@12345');
  console.log('4) Super Admin:          admin@xenobiz.local / admin');
  console.log('5) Support Admin:        support@xenobiz.local / support123');
  console.log('6) Read Only Admin:      auditor@xenobiz.local / readonly123');
  console.log('--------------------------------------------------');
}

seed()
  .then(() => process.exit(0))
  .catch((err) => {
    console.error('❌ Seeding failed:', err);
    process.exit(1);
  });
