/* ==========================================================================
   XenoBiz Admin Central Dashboard - Production Web Application Logic
   Stitch Project: 8769275243768709030 (Xenobiz Admin Core Design System)
   ========================================================================== */

const API_BASE_URL = '/api/v1';
let authToken = localStorage.getItem('xenobiz_admin_token') || null;
let currentAdmin = JSON.parse(localStorage.getItem('xenobiz_admin_user') || 'null');

let shopsData = [];
let revenueChart = null;
let plansChart = null;

// Initialize Web App
document.addEventListener('DOMContentLoaded', () => {
  setupEventListeners();

  if (authToken && currentAdmin) {
    showAppShell();
  } else {
    showAuthContainer();
  }
});

function setupEventListeners() {
  // Login Form Submission
  const loginForm = document.getElementById('login-form');
  if (loginForm) {
    loginForm.addEventListener('submit', handleLogin);
  }

  // Password Visibility Toggle
  const togglePwdBtn = document.getElementById('toggle-pwd');
  if (togglePwdBtn) {
    togglePwdBtn.addEventListener('click', () => {
      const pwdInput = document.getElementById('login-password');
      const pwdIcon = document.getElementById('pwd-icon');
      if (pwdInput.type === 'password') {
        pwdInput.type = 'text';
        pwdIcon.textContent = 'visibility';
      } else {
        pwdInput.type = 'password';
        pwdIcon.textContent = 'visibility_off';
      }
    });
  }
}

// ==================== AUTHENTICATION ====================
async function handleLogin(e) {
  e.preventDefault();
  const errorAlert = document.getElementById('login-error-alert');
  const submitBtn = document.getElementById('login-submit-btn');
  errorAlert.style.display = 'none';

  const loginId = document.getElementById('login-id').value.trim();
  const password = document.getElementById('login-password').value.trim();

  if (!loginId || !password) {
    showLoginError('Please enter admin login ID and password.');
    return;
  }

  submitBtn.disabled = true;
  submitBtn.innerHTML = '<span class="material-symbols-outlined">sync</span> SIGNING IN...';

  try {
    const response = await fetch(`${API_BASE_URL}/admin/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ identifier: loginId, password }),
    });

    const result = await response.json();

    if (response.ok && result.success) {
      authToken = result.data.token;
      currentAdmin = result.data.user || result.data.admin;

      localStorage.setItem('xenobiz_admin_token', authToken);
      localStorage.setItem('xenobiz_admin_user', JSON.stringify(currentAdmin));

      showAppShell();
    } else {
      showLoginError(result.message || 'Invalid admin credentials.');
    }
  } catch (err) {
    showLoginError('Failed to connect to backend server. Make sure server is running.');
  } finally {
    submitBtn.disabled = false;
    submitBtn.innerHTML = '<span class="material-symbols-outlined">login</span> ADMIN LOGIN';
  }
}

function showLoginError(msg) {
  const errorAlert = document.getElementById('login-error-alert');
  errorAlert.textContent = msg;
  errorAlert.style.display = 'block';
}

function logoutAdmin() {
  authToken = null;
  currentAdmin = null;
  localStorage.removeItem('xenobiz_admin_token');
  localStorage.removeItem('xenobiz_admin_user');
  showAuthContainer();
}

function showAuthContainer() {
  document.getElementById('auth-container').style.display = 'flex';
  document.getElementById('app-shell').style.display = 'none';
}

function showAppShell() {
  document.getElementById('auth-container').style.display = 'none';
  document.getElementById('app-shell').style.display = 'flex';

  if (currentAdmin) {
    document.getElementById('header-admin-name').textContent = currentAdmin.fullName || currentAdmin.name || 'Admin User';
    document.getElementById('header-admin-role').textContent = (currentAdmin.role || 'SUPER_ADMIN').toUpperCase();
    document.getElementById('header-admin-avatar').textContent = (currentAdmin.fullName || currentAdmin.name || 'A')[0].toUpperCase();
  }

  navigate('dashboard');
}

// ==================== NAVIGATION ====================
function navigate(route) {
  // Update sidebar active states
  document.querySelectorAll('.nav-item').forEach((item) => {
    if (item.getAttribute('data-route') === route) {
      item.classList.add('active');
    } else {
      item.classList.remove('active');
    }
  });

  // Hide all page views
  document.querySelectorAll('.page-view').forEach((view) => {
    view.style.display = 'none';
  });

  // Show selected view
  const targetView = document.getElementById(`view-${route}`);
  if (targetView) {
    targetView.style.display = 'block';
  }

  // Close sidebar drawer on mobile
  if (window.innerWidth <= 768) {
    document.getElementById('sidebar').classList.remove('open');
  }

  // Load view data
  switch (route) {
    case 'dashboard':
      loadDashboardData();
      break;
    case 'shops':
      loadShopsData();
      break;
    case 'customers':
      loadCustomersData();
      break;
    case 'subscriptions':
      loadSubscriptionsData();
      break;
    case 'plans':
      loadPlansData();
      break;
    case 'payments':
      loadPaymentsData();
      break;
    case 'configuration':
      loadConfigData();
      break;
    case 'feature-flags':
      loadFeatureFlagsData();
      break;
    case 'admins':
      loadAdminsData();
      break;
    case 'audit-logs':
      loadAuditLogsData();
      break;
  }
}

function toggleSidebar() {
  document.getElementById('sidebar').classList.toggle('open');
}

function toggleTheme() {
  document.body.classList.toggle('dark');
}

// API Helper
async function apiFetch(endpoint, options = {}) {
  const headers = {
    'Content-Type': 'application/json',
    ...(authToken ? { Authorization: `Bearer ${authToken}` } : {}),
    ...(options.headers || {}),
  };

  const response = await fetch(`${API_BASE_URL}${endpoint}`, { ...options, headers });
  if (response.status === 401) {
    logoutAdmin();
    throw new Error('Session expired.');
  }
  return await response.json();
}

// ==================== VIEW 1: DASHBOARD ====================
async function loadDashboardData() {
  try {
    const data = await apiFetch('/admin/dashboard');

    // Render KPI Cards
    const kpiContainer = document.getElementById('kpi-container');
    const summary = data.summary || {};

    const kpis = [
      { title: 'Total Shops', value: summary.totalShops || 0, icon: 'storefront', route: 'shops' },
      { title: 'Active Shops', value: summary.activeShops || 0, icon: 'check_circle', route: 'shops' },
      { title: 'Inactive Shops', value: summary.inactiveShops || 0, icon: 'pause_circle', route: 'shops' },
      { title: 'Suspended Shops', value: summary.suspendedShops || 0, icon: 'block', route: 'shops' },
      { title: 'Trial Shops', value: summary.trialShops || 0, icon: 'hourglass_empty', route: 'shops' },
      { title: 'Active Subs', value: summary.activeSubscriptions || 0, icon: 'card_membership', route: 'subscriptions' },
      { title: 'Expired Subs', value: summary.expiredSubscriptions || 0, icon: 'event_busy', route: 'subscriptions' },
      { title: 'Total Customers', value: summary.totalCustomers || 0, icon: 'group', route: 'customers' },
      { title: 'Total Revenue', value: `₹${(summary.totalRevenue || 0).toLocaleString()}`, icon: 'payments', route: 'payments' },
      { title: 'Monthly Revenue', value: `₹${(summary.monthlyRevenue || 0).toLocaleString()}`, icon: 'trending_up', route: 'payments' },
    ];

    kpiContainer.innerHTML = kpis.map((kpi) => `
      <div class="kpi-card" onclick="navigate('${kpi.route}')">
        <div class="kpi-header">
          <span class="kpi-title">${kpi.title}</span>
          <div class="kpi-icon"><span class="material-symbols-outlined">${kpi.icon}</span></div>
        </div>
        <div class="kpi-value">${kpi.value}</div>
      </div>
    `).join('');

    // Render Charts
    renderRevenueChart(data.analytics?.revenueTrend || []);
    renderPlansChart(data.analytics?.planDistribution || []);

    // Render Recent Shops Table
    const recentShops = data.recentShops || [];
    const tbody = document.getElementById('recent-shops-tbody');
    tbody.innerHTML = recentShops.map((s) => `
      <tr>
        <td style="font-weight: 700;">${s.shop_name || s.name}</td>
        <td>${s.owner_name || s.fullName}</td>
        <td>${s.email}</td>
        <td><span class="badge pro">${s.plan_name || 'Pro'}</span></td>
        <td><span class="badge ${s.status}">${s.status.toUpperCase()}</span></td>
        <td style="color: var(--text-muted);">${(s.created_at || '').substring(0, 10)}</td>
      </tr>
    `).join('');

  } catch (err) {
    console.error('Failed to load dashboard metrics:', err);
  }
}

function renderRevenueChart(trendData) {
  const ctx = document.getElementById('revenue-chart').getContext('2d');
  if (revenueChart) revenueChart.destroy();

  const labels = trendData.length ? trendData.map(d => d.month) : ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
  const values = trendData.length ? trendData.map(d => d.revenue) : [12000, 19000, 24000, 31000, 42000, 58000];

  revenueChart = new Chart(ctx, {
    type: 'line',
    data: {
      labels,
      datasets: [{
        label: 'Revenue (₹)',
        data: values,
        borderColor: '#0f62fe',
        backgroundColor: 'rgba(15, 98, 254, 0.1)',
        fill: true,
        tension: 0.4,
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: { legend: { display: false } }
    }
  });
}

function renderPlansChart(planData) {
  const ctx = document.getElementById('plans-chart').getContext('2d');
  if (plansChart) plansChart.destroy();

  const labels = planData.length ? planData.map(p => p.plan) : ['Free', 'Basic', 'Pro', 'Enterprise'];
  const values = planData.length ? planData.map(p => p.count) : [2, 1, 3, 1];

  plansChart = new Chart(ctx, {
    type: 'doughnut',
    data: {
      labels,
      datasets: [{
        data: values,
        backgroundColor: ['#94a3b8', '#3b82f6', '#0f62fe', '#6366f1'],
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
    }
  });
}

// ==================== VIEW 2: SHOPS ====================
async function loadShopsData() {
  try {
    const res = await apiFetch('/admin/shops');
    shopsData = res.data || [];
    renderShopsTable(shopsData);
  } catch (err) {
    console.error('Failed to load shops:', err);
  }
}

function renderShopsTable(shops) {
  const tbody = document.getElementById('shops-tbody');
  if (!shops.length) {
    tbody.innerHTML = '<tr><td colspan="7" style="text-align: center; color: var(--text-muted);">No shops found matching filters.</td></tr>';
    return;
  }

  tbody.innerHTML = shops.map((s) => `
    <tr>
      <td style="font-weight: 700;">
        ${s.shop_name || s.name || s.fullName}
        <div style="font-size: 11px; color: var(--text-muted);" class="mono">ID: ${s.id}</div>
      </td>
      <td>${s.owner_name || s.fullName}</td>
      <td>
        <div>${s.email}</div>
        <div style="font-size: 11px; color: var(--text-muted);">${s.phone || ''}</div>
      </td>
      <td class="mono">${s.login_id || s.loginId || ''}</td>
      <td><span class="badge pro">${s.plan_name || 'Pro'}</span></td>
      <td><span class="badge ${s.status}">${s.status.toUpperCase()}</span></td>
      <td>
        <button class="icon-btn" onclick="openShopDetails('${s.id}')" title="View Shop Profile">
          <span class="material-symbols-outlined" style="font-size: 18px;">visibility</span>
        </button>
      </td>
    </tr>
  `).join('');
}

function filterShops() {
  const query = document.getElementById('shops-search-input').value.toLowerCase();
  const status = document.getElementById('shops-status-select').value;

  const filtered = shopsData.filter((s) => {
    const matchesQuery = (s.shop_name || s.name || '').toLowerCase().includes(query) ||
                         (s.owner_name || s.fullName || '').toLowerCase().includes(query) ||
                         (s.email || '').toLowerCase().includes(query);
    const matchesStatus = status === 'all' || s.status.toLowerCase() === status;
    return matchesQuery && matchesStatus;
  });

  renderShopsTable(filtered);
}

function openCreateShopModal() {
  openModal('Create New Shop Account', `
    <form id="create-shop-form" onsubmit="handleCreateShop(event)">
      <div class="form-group">
        <label class="form-label">Shop / Business Name *</label>
        <input type="text" id="m-shop-name" class="form-control" style="padding-left: 14px;" required />
      </div>
      <div class="form-group">
        <label class="form-label">Owner Full Name *</label>
        <input type="text" id="m-owner-name" class="form-control" style="padding-left: 14px;" required />
      </div>
      <div class="form-group">
        <label class="form-label">Email Address *</label>
        <input type="email" id="m-email" class="form-control" style="padding-left: 14px;" required />
      </div>
      <div class="form-group">
        <label class="form-label">Phone Number</label>
        <input type="text" id="m-phone" class="form-control" style="padding-left: 14px;" />
      </div>
      <div class="form-group">
        <label class="form-label">Initial Password *</label>
        <input type="password" id="m-password" class="form-control" style="padding-left: 14px;" value="Demo@12345" required />
      </div>
      <button type="submit" class="btn-primary">CREATE SHOP ACCOUNT</button>
    </form>
  `);
}

async function handleCreateShop(e) {
  e.preventDefault();
  const payload = {
    name: document.getElementById('m-shop-name').value.trim(),
    fullName: document.getElementById('m-owner-name').value.trim(),
    email: document.getElementById('m-email').value.trim(),
    phone: document.getElementById('m-phone').value.trim(),
    password: document.getElementById('m-password').value.trim(),
  };

  try {
    await apiFetch('/admin/shops', { method: 'POST', body: JSON.stringify(payload) });
    closeModal();
    loadShopsData();
    alert('Shop created successfully!');
  } catch (err) {
    alert(`Failed to create shop: ${err.message}`);
  }
}

async function openShopDetails(id) {
  try {
    const res = await apiFetch(`/admin/shops/${id}`);
    const shop = res.data || {};
    openModal(`Shop Details - ${shop.shop_name || shop.name}`, `
      <div style="display: flex; flex-direction: column; gap: 12px; font-size: 14px;">
        <div><strong>Shop ID:</strong> <span class="mono">${shop.id}</span></div>
        <div><strong>Owner Name:</strong> ${shop.owner_name || shop.fullName}</div>
        <div><strong>Email:</strong> ${shop.email}</div>
        <div><strong>Phone:</strong> ${shop.phone || 'N/A'}</div>
        <div><strong>Login ID:</strong> <span class="mono">${shop.login_id || shop.loginId}</span></div>
        <div><strong>Account Status:</strong> <span class="badge ${shop.status}">${shop.status}</span></div>
        <div><strong>Subscription Plan:</strong> ${shop.plan_name || 'Pro Plan'}</div>
        <div><strong>Registered Date:</strong> ${(shop.created_at || '').substring(0, 10)}</div>
      </div>
    `);
  } catch (err) {
    alert('Failed to load shop details.');
  }
}

// ==================== VIEW 3: CUSTOMERS ====================
async function loadCustomersData() {
  try {
    const res = await apiFetch('/admin/customers');
    const customers = res.data || [];
    const tbody = document.getElementById('customers-tbody');

    if (!customers.length) {
      tbody.innerHTML = '<tr><td colspan="7" style="text-align: center; color: var(--text-muted);">No customers found.</td></tr>';
      return;
    }

    tbody.innerHTML = customers.map((c) => `
      <tr>
        <td style="font-weight: 700;">${c.name}</td>
        <td>
          <div>${c.email || 'N/A'}</div>
          <div style="font-size: 11px; color: var(--text-muted);">${c.phone || ''}</div>
        </td>
        <td>${c.shop_name || 'Standalone'}</td>
        <td>${c.city || ''}, ${c.state || ''}</td>
        <td style="font-weight: 700;">₹${(c.total_spent || 0).toLocaleString()}</td>
        <td><span class="badge ${c.status}">${c.status.toUpperCase()}</span></td>
        <td>
          <button class="icon-btn" onclick="alert('Customer details view')" title="View Customer"><span class="material-symbols-outlined" style="font-size: 18px;">visibility</span></button>
        </td>
      </tr>
    `).join('');
  } catch (err) {
    console.error('Failed to load customers:', err);
  }
}

function openAddCustomerModal() {
  openModal('Add New Customer', `
    <form onsubmit="handleAddCustomer(event)">
      <div class="form-group">
        <label class="form-label">Customer Name *</label>
        <input type="text" id="mc-name" class="form-control" style="padding-left: 14px;" required />
      </div>
      <div class="form-group">
        <label class="form-label">Email Address</label>
        <input type="email" id="mc-email" class="form-control" style="padding-left: 14px;" />
      </div>
      <div class="form-group">
        <label class="form-label">Phone Number</label>
        <input type="text" id="mc-phone" class="form-control" style="padding-left: 14px;" />
      </div>
      <button type="submit" class="btn-primary">CREATE CUSTOMER</button>
    </form>
  `);
}

async function handleAddCustomer(e) {
  e.preventDefault();
  const payload = {
    name: document.getElementById('mc-name').value.trim(),
    email: document.getElementById('mc-email').value.trim(),
    phone: document.getElementById('mc-phone').value.trim(),
  };

  try {
    await apiFetch('/admin/customers', { method: 'POST', body: JSON.stringify(payload) });
    closeModal();
    loadCustomersData();
  } catch (err) {
    alert(`Failed to add customer: ${err.message}`);
  }
}

// ==================== VIEW 4: SUBSCRIPTIONS ====================
async function loadSubscriptionsData() {
  try {
    const res = await apiFetch('/admin/subscriptions');
    const subs = res.data || [];
    const tbody = document.getElementById('subscriptions-tbody');

    tbody.innerHTML = subs.map((s) => `
      <tr>
        <td style="font-weight: 700;">${s.shop_name || s.shopId}</td>
        <td><span class="badge pro">${s.plan_name || s.planId}</span></td>
        <td>${s.billing_cycle || 'Monthly'}</td>
        <td style="font-weight: 700;">₹${s.amount}</td>
        <td>${(s.start_date || '').substring(0, 10)}</td>
        <td>${(s.end_date || '').substring(0, 10)}</td>
        <td><span class="badge ${s.status}">${s.status.toUpperCase()}</span></td>
      </tr>
    `).join('');
  } catch (err) {
    console.error('Failed to load subscriptions:', err);
  }
}

// ==================== VIEW 5: PLANS ====================
async function loadPlansData() {
  try {
    const res = await apiFetch('/admin/plans');
    const plans = res.data || [];
    const container = document.getElementById('plans-grid-container');

    container.innerHTML = plans.map((p) => `
      <div class="kpi-card" style="align-items: flex-start;">
        <div style="display: flex; justify-content: space-between; width: 100%;">
          <span class="badge pro">${p.name}</span>
          <span class="badge ${p.is_active ? 'active' : 'inactive'}">${p.is_active ? 'ACTIVE' : 'DISABLED'}</span>
        </div>
        <div class="kpi-value" style="margin-top: 8px;">₹${p.price} <span style="font-size: 13px; color: var(--text-muted); font-weight: 400;">/ ${p.billing_cycle}</span></div>
        <p style="font-size: 13px; color: var(--text-secondary); margin: 8px 0;">${p.description || ''}</p>
        <div style="font-size: 12px; color: var(--text-muted);">Subscribers: <strong>${p.subscriber_count || 0} shops</strong></div>
      </div>
    `).join('');
  } catch (err) {
    console.error('Failed to load plans:', err);
  }
}

// ==================== VIEW 6: PAYMENTS ====================
async function loadPaymentsData() {
  try {
    const res = await apiFetch('/admin/purchases');
    const payments = res.data || [];
    const tbody = document.getElementById('payments-tbody');

    tbody.innerHTML = payments.map((p) => `
      <tr>
        <td class="mono" style="font-weight: 600;">${p.transaction_id || p.id}</td>
        <td style="font-weight: 700;">${p.shop_name || p.shopId}</td>
        <td>${p.plan_name || 'Pro Plan'}</td>
        <td style="font-weight: 700;">₹${p.amount}</td>
        <td>${(p.provider || 'razorpay').toUpperCase()}</td>
        <td><span class="badge ${p.status}">${p.status.toUpperCase()}</span></td>
        <td style="color: var(--text-muted);">${(p.paid_at || '').substring(0, 10)}</td>
      </tr>
    `).join('');
  } catch (err) {
    console.error('Failed to load payments:', err);
  }
}

// ==================== VIEW 7: CONFIGURATION ====================
async function loadConfigData() {
  try {
    const res = await apiFetch('/admin/config');
    const general = (res.data && res.data.general) || {};
    document.getElementById('cfg-app-name').value = general.app_name || 'XenoBiz Business Manager';
    document.getElementById('cfg-min-ver').value = general.min_app_version || '1.2.0';
    document.getElementById('cfg-email').value = general.support_email || 'support@xenobiz.com';
  } catch (err) {
    console.error('Failed to load configuration:', err);
  }
}

async function saveGeneralConfig() {
  const payload = {
    app_name: document.getElementById('cfg-app-name').value.trim(),
    min_app_version: document.getElementById('cfg-min-ver').value.trim(),
    support_email: document.getElementById('cfg-email').value.trim(),
  };

  try {
    await apiFetch('/admin/config/general', { method: 'PUT', body: JSON.stringify(payload) });
    alert('Configuration saved successfully!');
  } catch (err) {
    alert(`Failed to save config: ${err.message}`);
  }
}

// ==================== VIEW 8: FEATURE FLAGS ====================
async function loadFeatureFlagsData() {
  try {
    const res = await apiFetch('/admin/feature-flags');
    const flags = res.data || [];
    const tbody = document.getElementById('flags-tbody');

    tbody.innerHTML = flags.map((f) => `
      <tr>
        <td style="font-weight: 700;">${f.name}</td>
        <td class="mono">${f.key}</td>
        <td><span class="badge pro">${(f.environment || 'production').toUpperCase()}</span></td>
        <td style="color: var(--text-secondary); font-size: 12px;">${f.description || ''}</td>
        <td><span class="badge ${f.is_enabled ? 'active' : 'inactive'}">${f.is_enabled ? 'ENABLED' : 'DISABLED'}</span></td>
        <td>
          <button class="btn-primary" style="width: auto; padding: 6px 12px; font-size: 11px;" onclick="toggleFlag('${f.key}')">TOGGLE</button>
        </td>
      </tr>
    `).join('');
  } catch (err) {
    console.error('Failed to load feature flags:', err);
  }
}

async function toggleFlag(key) {
  try {
    await apiFetch(`/admin/feature-flags/${key}/toggle`, { method: 'PUT' });
    loadFeatureFlagsData();
  } catch (err) {
    alert('Failed to toggle feature flag.');
  }
}

// ==================== VIEW 9: ADMIN MANAGEMENT ====================
async function loadAdminsData() {
  try {
    const res = await apiFetch('/admin/admins');
    const admins = res.data || [];
    const tbody = document.getElementById('admins-tbody');

    tbody.innerHTML = admins.map((a) => `
      <tr>
        <td style="font-weight: 700;">${a.name}</td>
        <td>${a.email}</td>
        <td class="mono">${a.login_id || a.loginId}</td>
        <td><span class="badge pro">${a.role}</span></td>
        <td><span class="badge ${a.status}">${a.status.toUpperCase()}</span></td>
        <td>
          <button class="icon-btn" onclick="alert('Reset password dialog')" title="Reset Password"><span class="material-symbols-outlined" style="font-size: 18px;">lock_reset</span></button>
        </td>
      </tr>
    `).join('');
  } catch (err) {
    console.error('Failed to load admin users:', err);
  }
}

function openCreateAdminModal() {
  openModal('Create New Admin Account', `
    <form onsubmit="handleCreateAdmin(event)">
      <div class="form-group">
        <label class="form-label">Full Name *</label>
        <input type="text" id="ma-name" class="form-control" style="padding-left: 14px;" required />
      </div>
      <div class="form-group">
        <label class="form-label">Email Address *</label>
        <input type="email" id="ma-email" class="form-control" style="padding-left: 14px;" required />
      </div>
      <div class="form-group">
        <label class="form-label">Login ID / Username *</label>
        <input type="text" id="ma-loginid" class="form-control" style="padding-left: 14px;" required />
      </div>
      <div class="form-group">
        <label class="form-label">Password *</label>
        <input type="password" id="ma-password" class="form-control" style="padding-left: 14px;" required />
      </div>
      <div class="form-group">
        <label class="form-label">Role & Permissions</label>
        <select id="ma-role" class="form-control" style="padding-left: 14px;">
          <option value="SUPER_ADMIN">Super Admin (Full Access)</option>
          <option value="ADMIN">Admin (Standard Access)</option>
          <option value="SUPPORT_ADMIN">Support Admin (Customer Support)</option>
          <option value="READ_ONLY">Read Only (Auditor)</option>
        </select>
      </div>
      <button type="submit" class="btn-primary">CREATE ADMIN ACCOUNT</button>
    </form>
  `);
}

async function handleCreateAdmin(e) {
  e.preventDefault();
  const payload = {
    name: document.getElementById('ma-name').value.trim(),
    email: document.getElementById('ma-email').value.trim(),
    loginId: document.getElementById('ma-loginid').value.trim(),
    password: document.getElementById('ma-password').value.trim(),
    role: document.getElementById('ma-role').value,
  };

  try {
    await apiFetch('/admin/admins', { method: 'POST', body: JSON.stringify(payload) });
    closeModal();
    loadAdminsData();
  } catch (err) {
    alert(`Failed to create admin: ${err.message}`);
  }
}

// ==================== VIEW 10: AUDIT LOGS ====================
async function loadAuditLogsData() {
  try {
    const res = await apiFetch('/admin/audit-logs');
    const logs = res.data || [];
    const tbody = document.getElementById('audit-logs-tbody');

    tbody.innerHTML = logs.map((l) => `
      <tr>
        <td style="font-weight: 700;">${l.action}</td>
        <td>${l.admin_name || l.adminName}</td>
        <td><span class="badge pro">${l.target_type || 'SYSTEM'}</span></td>
        <td class="mono">${l.target_id || 'N/A'}</td>
        <td class="mono">${l.ip_address || '127.0.0.1'}</td>
        <td style="color: var(--text-muted);">${(l.created_at || '').substring(0, 10)}</td>
      </tr>
    `).join('');
  } catch (err) {
    console.error('Failed to load audit logs:', err);
  }
}

// ==================== MODAL HELPERS ====================
function openModal(title, contentHtml) {
  document.getElementById('modal-title').textContent = title;
  document.getElementById('modal-body').innerHTML = contentHtml;
  document.getElementById('modal-overlay').style.display = 'flex';
}

function closeModal() {
  document.getElementById('modal-overlay').style.display = 'none';
}
