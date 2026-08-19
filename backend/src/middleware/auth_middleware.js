const jwt = require('jsonwebtoken');
const env = require('../config/env');
const adminRepository = require('../repositories/admin_repository');
const shopRepository = require('../repositories/shop_repository');

async function authenticateToken(req, res, next) {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({
      success: false,
      message: 'Authentication token missing or unauthorized.',
    });
  }

  try {
    const decoded = jwt.verify(token, env.JWT_SECRET);
    const targetId = decoded.adminId || decoded.shopId || decoded.userId;

    if (decoded.role === 'ADMIN' || decoded.isAdmin || decoded.adminId) {
      const admin = await adminRepository.findById(targetId);
      if (!admin) {
        return res.status(401).json({
          success: false,
          message: 'Admin account not found.',
        });
      }

      if (admin.status !== 'active') {
        return res.status(403).json({
          success: false,
          message: `Admin account is currently ${admin.status}.`,
        });
      }

      req.user = {
        id: admin.id,
        adminId: admin.id,
        userId: admin.id,
        email: admin.email,
        role: admin.role || 'ADMIN',
        fullName: admin.name,
        shopName: 'XenoBiz Admin Platform',
      };
      req.admin = admin;
      return next();
    }

    const shop = await shopRepository.findById(targetId);

    if (!shop) {
      return res.status(401).json({
        success: false,
        message: 'Account not found.',
      });
    }

    if (shop.status !== 'active') {
      return res.status(403).json({
        success: false,
        message: `Account is currently ${shop.status}.`,
      });
    }

    req.user = {
      shopId: shop.id,
      userId: shop.id,
      email: shop.email,
      role: shop.role,
      fullName: shop.owner_name,
      shopName: shop.shop_name,
    };

    req.shop = shop;
    next();
  } catch (err) {
    return res.status(403).json({
      success: false,
      message: 'Invalid or expired authentication token.',
    });
  }
}

module.exports = {
  authenticateToken,
};
