const { pool } = require('../db/database');

class CustomerRepository {
  async create({
    id,
    shopId,
    name,
    email,
    phone,
    city,
    state,
    country = 'India',
    status = 'active',
    totalSpent = 0.0,
    totalPurchases = 0,
  }) {
    const query = `
      INSERT INTO customers (
        id, shop_id, name, email, phone, city, state, country, status, total_spent, total_purchases, created_at, updated_at
      ) VALUES (
        $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, NOW(), NOW()
      )
      RETURNING *;
    `;
    const values = [
      id,
      shopId || null,
      name,
      email || null,
      phone || null,
      city || null,
      state || null,
      country,
      status,
      totalSpent,
      totalPurchases,
    ];
    const result = await pool.query(query, values);
    return result.rows[0];
  }

  async findAll({ search, status, shopId, limit = 50, offset = 0 } = {}) {
    let query = `
      SELECT c.*, s.shop_name, s.owner_name as shop_owner
      FROM customers c
      LEFT JOIN shops s ON c.shop_id = s.id
      WHERE 1=1
    `;
    const values = [];
    let idx = 1;

    if (status && status !== 'all') {
      query += ` AND c.status = $${idx}`;
      values.push(status);
      idx++;
    }

    if (shopId) {
      query += ` AND c.shop_id = $${idx}`;
      values.push(shopId);
      idx++;
    }

    if (search) {
      query += ` AND (LOWER(c.name) LIKE $${idx} OR LOWER(c.email) LIKE $${idx} OR c.phone LIKE $${idx})`;
      values.push(`%${search.trim().toLowerCase()}%`);
      idx++;
    }

    query += ` ORDER BY c.created_at DESC LIMIT $${idx} OFFSET $${idx + 1};`;
    values.push(limit, offset);

    const result = await pool.query(query, values);
    return result.rows;
  }

  async count({ search, status, shopId } = {}) {
    let query = `SELECT COUNT(*) as count FROM customers c WHERE 1=1`;
    const values = [];
    let idx = 1;

    if (status && status !== 'all') {
      query += ` AND c.status = $${idx}`;
      values.push(status);
      idx++;
    }

    if (shopId) {
      query += ` AND c.shop_id = $${idx}`;
      values.push(shopId);
      idx++;
    }

    if (search) {
      query += ` AND (LOWER(c.name) LIKE $${idx} OR LOWER(c.email) LIKE $${idx} OR c.phone LIKE $${idx})`;
      values.push(`%${search.trim().toLowerCase()}%`);
      idx++;
    }

    const result = await pool.query(query, values);
    return parseInt(result.rows[0].count, 10);
  }

  async findById(id) {
    const query = `
      SELECT c.*, s.shop_name
      FROM customers c
      LEFT JOIN shops s ON c.shop_id = s.id
      WHERE c.id = $1;
    `;
    const result = await pool.query(query, [id]);
    return result.rows[0] || null;
  }

  async update(id, updates) {
    const fields = [];
    const values = [];
    let idx = 1;

    const columnMapping = {
      shopId: 'shop_id',
      name: 'name',
      email: 'email',
      phone: 'phone',
      city: 'city',
      state: 'state',
      country: 'country',
      status: 'status',
      totalSpent: 'total_spent',
      totalPurchases: 'total_purchases',
    };

    for (const [key, value] of Object.entries(updates)) {
      const dbCol = columnMapping[key] || key;
      fields.push(`${dbCol} = $${idx}`);
      values.push(value);
      idx++;
    }

    fields.push(`updated_at = NOW()`);
    values.push(id);

    const query = `
      UPDATE customers
      SET ${fields.join(', ')}
      WHERE id = $${idx}
      RETURNING *;
    `;
    const result = await pool.query(query, values);
    return result.rows[0] || null;
  }

  async delete(id) {
    const query = `DELETE FROM customers WHERE id = $1 RETURNING *;`;
    const result = await pool.query(query, [id]);
    return result.rows[0] || null;
  }
}

module.exports = new CustomerRepository();
