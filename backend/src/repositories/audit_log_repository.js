const { pool } = require('../db/database');

class AuditLogRepository {
  async create({ id, adminId, adminName, action, targetType, targetId, details = {}, ipAddress }) {
    const query = `
      INSERT INTO audit_logs (
        id, admin_id, admin_name, action, target_type, target_id, details, ip_address, created_at
      ) VALUES (
        $1, $2, $3, $4, $5, $6, $7, $8, NOW()
      )
      RETURNING *;
    `;
    const values = [
      id,
      adminId || null,
      adminName || 'System Admin',
      action,
      targetType || null,
      targetId || null,
      JSON.stringify(details),
      ipAddress || '127.0.0.1',
    ];
    const result = await pool.query(query, values);
    return result.rows[0];
  }

  async findAll({ search, action, limit = 100, offset = 0 } = {}) {
    let query = `SELECT * FROM audit_logs WHERE 1=1`;
    const values = [];
    let idx = 1;

    if (action && action !== 'all') {
      query += ` AND action = $${idx}`;
      values.push(action);
      idx++;
    }

    if (search) {
      query += ` AND (LOWER(admin_name) LIKE $${idx} OR LOWER(action) LIKE $${idx} OR LOWER(target_type) LIKE $${idx} OR LOWER(target_id) LIKE $${idx})`;
      values.push(`%${search.trim().toLowerCase()}%`);
      idx++;
    }

    query += ` ORDER BY created_at DESC LIMIT $${idx} OFFSET $${idx + 1};`;
    values.push(limit, offset);

    const result = await pool.query(query, values);
    return result.rows;
  }
}

module.exports = new AuditLogRepository();
