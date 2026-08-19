const express = require('express');
const router = express.Router();
const adminController = require('../controllers/admin_controller');

// Admin Authentication & Creation Routes
router.post('/login', adminController.login);
router.post('/auth/login', adminController.login);
router.post('/create', adminController.createAdmin);

// Dashboard Routes
router.get('/dashboard', adminController.getDashboard);
router.get('/dashboard/summary', adminController.getDashboard);

// Shops & Accounts Routes
router.get('/shops', adminController.getShops);
router.post('/shops', adminController.createShop);
router.get('/shops/:id', adminController.getShopDetails);
router.put('/shops/:id', adminController.updateShop);
router.put('/shops/:id/status', adminController.updateShopStatus);
router.delete('/shops/:id', adminController.deleteShop);

router.get('/accounts', adminController.getShops);
router.post('/accounts', adminController.createShop);
router.get('/accounts/:id', adminController.getShopDetails);
router.put('/accounts/:id', adminController.updateShop);
router.put('/accounts/:id/status', adminController.updateShopStatus);
router.delete('/accounts/:id', adminController.deleteShop);

// Businesses & Companies Routes
router.get('/businesses', adminController.getShops);
router.get('/businesses/:id', adminController.getShopDetails);
router.put('/businesses/:id', adminController.updateShopStatus);

router.get('/companies', adminController.getShops);
router.get('/companies/:id', adminController.getShopDetails);
router.put('/companies/:id', adminController.updateShopStatus);

// Customers Routes
router.get('/customers', adminController.getCustomers);
router.post('/customers', adminController.createCustomer);
router.get('/customers/:id', adminController.getCustomerDetails);
router.put('/customers/:id', adminController.updateCustomer);
router.delete('/customers/:id', adminController.deleteCustomer);

// Plans Routes
router.get('/plans', adminController.getPlans);
router.get('/plans/:id', adminController.getPlanDetails);
router.post('/plans', adminController.createPlan);
router.put('/plans/:id', adminController.updatePlan);
router.post('/plans/:id/toggle', adminController.togglePlanStatus);

// Subscriptions Routes
router.get('/subscriptions', adminController.getSubscriptions);
router.get('/subscriptions/:id', adminController.getSubscriptionDetails);

// Purchases & Payments Routes
router.get('/purchases', adminController.getPurchases);
router.get('/purchases/:id', adminController.getPurchaseDetails);

router.get('/payments', adminController.getPurchases);
router.get('/payments/:id', adminController.getPurchaseDetails);

// App Configuration Routes
router.get('/config', adminController.getAppConfigs);
router.put('/config/:category', adminController.updateAppConfigCategory);

// Feature Flags Routes
router.get('/feature-flags', adminController.getFeatureFlags);
router.put('/feature-flags/:key/toggle', adminController.toggleFeatureFlag);
router.put('/feature-flags/:key', adminController.updateFeatureFlag);

// Admin Management Routes
router.get('/admins', adminController.getAdmins);
router.post('/admins', adminController.createAdmin);
router.put('/admins/:id', adminController.updateAdmin);
router.put('/admins/:id/status', adminController.updateAdminStatus);
router.post('/admins/:id/reset-password', adminController.resetAdminPassword);
router.delete('/admins/:id', adminController.deleteAdmin);

// Audit Logs Routes
router.get('/audit-logs', adminController.getAuditLogs);

module.exports = router;
