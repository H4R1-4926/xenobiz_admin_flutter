const adminService = require('../services/admin_service');

class AdminController {
  async login(req, res, next) {
    try {
      const { email, username, loginId, emailOrUsername, identifier, password } = req.body;
      const cleanIdentifier = identifier || email || username || loginId || emailOrUsername;

      const result = await adminService.adminLogin({
        identifier: cleanIdentifier,
        password,
      });

      res.json({
        success: true,
        message: 'Admin login successful!',
        data: result,
      });
    } catch (err) {
      next(err);
    }
  }

  async createAdmin(req, res, next) {
    try {
      const { name, email, loginId, password, role } = req.body;
      const result = await adminService.createAdmin({ name, email, loginId, password, role });
      res.status(201).json({
        success: true,
        message: 'Admin account created successfully.',
        data: result,
      });
    } catch (err) {
      next(err);
    }
  }

  async getDashboard(req, res, next) {
    try {
      const data = await adminService.getDashboardData();
      res.json({
        success: true,
        data,
        ...data,
      });
    } catch (err) {
      next(err);
    }
  }

  async getShops(req, res, next) {
    try {
      const { status, query, search } = req.query;
      const data = await adminService.getAllShops({ status, query, search });
      res.json({
        success: true,
        data,
      });
    } catch (err) {
      next(err);
    }
  }

  async getShopDetails(req, res, next) {
    try {
      const { id } = req.params;
      const data = await adminService.getShopDetails(id);
      res.json({
        success: true,
        data,
      });
    } catch (err) {
      next(err);
    }
  }

  async updateShopStatus(req, res, next) {
    try {
      const { id } = req.params;
      const { status } = req.body;
      const data = await adminService.updateShopStatus(id, { status });
      res.json({
        success: true,
        message: 'Shop account status updated successfully.',
        data,
      });
    } catch (err) {
      next(err);
    }
  }

  // Admin Plans
  async getPlans(req, res, next) {
    try {
      const data = await adminService.getAllPlans();
      res.json({
        success: true,
        data,
      });
    } catch (err) {
      next(err);
    }
  }

  async getPlanDetails(req, res, next) {
    try {
      const { id } = req.params;
      const data = await adminService.getPlanById(id);
      res.json({
        success: true,
        data,
      });
    } catch (err) {
      next(err);
    }
  }

  async createPlan(req, res, next) {
    try {
      const data = await adminService.createPlan(req.body);
      res.status(201).json({
        success: true,
        message: 'Plan created successfully.',
        data,
      });
    } catch (err) {
      next(err);
    }
  }

  async updatePlan(req, res, next) {
    try {
      const { id } = req.params;
      const data = await adminService.updatePlan(id, req.body);
      res.json({
        success: true,
        message: 'Plan updated successfully.',
        data,
      });
    } catch (err) {
      next(err);
    }
  }

  async togglePlanStatus(req, res, next) {
    try {
      const { id } = req.params;
      const data = await adminService.togglePlanStatus(id);
      res.json({
        success: true,
        message: 'Plan status toggled successfully.',
        data,
      });
    } catch (err) {
      next(err);
    }
  }

  // Admin Subscriptions
  async getSubscriptions(req, res, next) {
    try {
      const { status, search, limit, page } = req.query;
      const data = await adminService.getAllSubscriptions({
        status,
        search,
        limit: limit ? parseInt(limit, 10) : 50,
        page: page ? parseInt(page, 10) : 1,
      });
      res.json({
        success: true,
        data,
      });
    } catch (err) {
      next(err);
    }
  }

  async getSubscriptionDetails(req, res, next) {
    try {
      const { id } = req.params;
      const data = await adminService.getSubscriptionById(id);
      res.json({
        success: true,
        data,
      });
    } catch (err) {
      next(err);
    }
  }

  // Admin Purchases / Payments
  async getPurchases(req, res, next) {
    try {
      const { status, search, limit, page } = req.query;
      const data = await adminService.getAllPurchases({
        status,
        search,
        limit: limit ? parseInt(limit, 10) : 50,
        page: page ? parseInt(page, 10) : 1,
      });
      res.json({
        success: true,
        data,
      });
    } catch (err) {
      next(err);
    }
  }

  async getPurchaseDetails(req, res, next) {
    try {
      const { id } = req.params;
      const data = await adminService.getPurchaseById(id);
      res.json({
        success: true,
        data,
      });
    } catch (err) {
      next(err);
    }
  }

  // Shop CRUD
  async createShop(req, res, next) {
    try {
      const adminContext = req.user || {};
      const data = await adminService.createShop(req.body, adminContext);
      res.status(201).json({
        success: true,
        message: 'Shop created successfully.',
        data,
      });
    } catch (err) {
      next(err);
    }
  }

  async updateShop(req, res, next) {
    try {
      const { id } = req.params;
      const adminContext = req.user || {};
      const data = await adminService.updateShop(id, req.body, adminContext);
      res.json({
        success: true,
        message: 'Shop updated successfully.',
        data,
      });
    } catch (err) {
      next(err);
    }
  }

  async deleteShop(req, res, next) {
    try {
      const { id } = req.params;
      const adminContext = req.user || {};
      const data = await adminService.deleteShop(id, adminContext);
      res.json({
        success: true,
        message: 'Shop status suspended/deleted successfully.',
        data,
      });
    } catch (err) {
      next(err);
    }
  }

  // Customer Management
  async getCustomers(req, res, next) {
    try {
      const { search, status, shopId, limit, page } = req.query;
      const data = await adminService.getAllCustomers({
        search,
        status,
        shopId,
        limit: limit ? parseInt(limit, 10) : 50,
        page: page ? parseInt(page, 10) : 1,
      });
      res.json({
        success: true,
        data: data.items,
        total: data.total,
        page: data.page,
        limit: data.limit,
      });
    } catch (err) {
      next(err);
    }
  }

  async getCustomerDetails(req, res, next) {
    try {
      const { id } = req.params;
      const data = await adminService.getCustomerById(id);
      res.json({
        success: true,
        data,
      });
    } catch (err) {
      next(err);
    }
  }

  async createCustomer(req, res, next) {
    try {
      const data = await adminService.createCustomer(req.body);
      res.status(201).json({
        success: true,
        message: 'Customer created successfully.',
        data,
      });
    } catch (err) {
      next(err);
    }
  }

  async updateCustomer(req, res, next) {
    try {
      const { id } = req.params;
      const data = await adminService.updateCustomer(id, req.body);
      res.json({
        success: true,
        message: 'Customer updated successfully.',
        data,
      });
    } catch (err) {
      next(err);
    }
  }

  async deleteCustomer(req, res, next) {
    try {
      const { id } = req.params;
      const data = await adminService.deleteCustomer(id);
      res.json({
        success: true,
        message: 'Customer deleted successfully.',
        data,
      });
    } catch (err) {
      next(err);
    }
  }

  // App Configuration
  async getAppConfigs(req, res, next) {
    try {
      const data = await adminService.getAppConfigs();
      res.json({
        success: true,
        data,
      });
    } catch (err) {
      next(err);
    }
  }

  async updateAppConfigCategory(req, res, next) {
    try {
      const { category } = req.params;
      const adminContext = req.user || {};
      const data = await adminService.updateAppConfigCategory(category, req.body, adminContext);
      res.json({
        success: true,
        message: `App configuration for category ${category} updated successfully.`,
        data,
      });
    } catch (err) {
      next(err);
    }
  }

  // Feature Flags
  async getFeatureFlags(req, res, next) {
    try {
      const data = await adminService.getFeatureFlags();
      res.json({
        success: true,
        data,
      });
    } catch (err) {
      next(err);
    }
  }

  async toggleFeatureFlag(req, res, next) {
    try {
      const { key } = req.params;
      const adminContext = req.user || {};
      const data = await adminService.toggleFeatureFlag(key, adminContext);
      res.json({
        success: true,
        message: `Feature flag '${key}' status toggled successfully.`,
        data,
      });
    } catch (err) {
      next(err);
    }
  }

  async updateFeatureFlag(req, res, next) {
    try {
      const { key } = req.params;
      const adminContext = req.user || {};
      const data = await adminService.updateFeatureFlag(key, req.body, adminContext);
      res.json({
        success: true,
        message: `Feature flag '${key}' updated successfully.`,
        data,
      });
    } catch (err) {
      next(err);
    }
  }

  // Admin Management
  async getAdmins(req, res, next) {
    try {
      const data = await adminService.getAllAdmins();
      res.json({
        success: true,
        data,
      });
    } catch (err) {
      next(err);
    }
  }

  async updateAdmin(req, res, next) {
    try {
      const { id } = req.params;
      const data = await adminService.updateAdmin(id, req.body);
      res.json({
        success: true,
        message: 'Admin account updated successfully.',
        data,
      });
    } catch (err) {
      next(err);
    }
  }

  async updateAdminStatus(req, res, next) {
    try {
      const { id } = req.params;
      const { status } = req.body;
      const data = await adminService.updateAdminStatus(id, status);
      res.json({
        success: true,
        message: 'Admin status updated successfully.',
        data,
      });
    } catch (err) {
      next(err);
    }
  }

  async resetAdminPassword(req, res, next) {
    try {
      const { id } = req.params;
      const { password } = req.body;
      if (!password) throw { statusCode: 400, message: 'New password is required.' };
      const data = await adminService.resetAdminPassword(id, password);
      res.json({
        success: true,
        message: 'Admin password reset successfully.',
        data,
      });
    } catch (err) {
      next(err);
    }
  }

  async deleteAdmin(req, res, next) {
    try {
      const { id } = req.params;
      const data = await adminService.deleteAdmin(id);
      res.json({
        success: true,
        message: 'Admin account deleted successfully.',
        data,
      });
    } catch (err) {
      next(err);
    }
  }

  // Audit Logs
  async getAuditLogs(req, res, next) {
    try {
      const { search, action, limit, page } = req.query;
      const data = await adminService.getAuditLogs({
        search,
        action,
        limit: limit ? parseInt(limit, 10) : 100,
        page: page ? parseInt(page, 10) : 1,
      });
      res.json({
        success: true,
        data,
      });
    } catch (err) {
      next(err);
    }
  }
}

module.exports = new AdminController();
