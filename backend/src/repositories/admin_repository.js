const { adminQuery } = require('../db/database');

class AdminRepository {
  async create({
    id,
    name,
    email,
    loginId,
    passwordHash,
    status = 'active',
    role = 'ADMIN',
  }) {
    const query = `
      INSERT INTO admins (
        id, name, email, login_id, password_hash, status, role, created_at, updated_at
      ) VALUES (
        $1, $2, $3, $4, $5, $6, $7, NOW(), NOW()
      )
      RETURNING *;
    `;
    const values = [
      id,
      name,
      email,
      loginId || null,
      passwordHash,
      status,
      role,
    ];

    const result = await adminQuery(query, values);
    return result.rows[0];
  }

  async findByEmail(email) {
    if (!email) return null;
    const query = `SELECT * FROM admins WHERE LOWER(email) = LOWER($1);`;
    const result = await adminQuery(query, [email.trim()]);
    return result.rows[0] || null;
  }

  async findByLoginId(loginId) {
    if (!loginId) return null;
    const query = `SELECT * FROM admins WHERE LOWER(login_id) = LOWER($1);`;
    const result = await adminQuery(query, [loginId.trim()]);
    return result.rows[0] || null;
  }

  async findByEmailOrLoginId(identifier) {
    if (!identifier) return null;
    const clean = identifier.trim().toLowerCase();
    const query = `
      SELECT * FROM admins 
      WHERE LOWER(email) = $1 OR LOWER(login_id) = $1;
    `;
    const result = await adminQuery(query, [clean]);
    return result.rows[0] || null;
  }

  async findById(id) {
    if (!id) return null;
    const query = `SELECT * FROM admins WHERE id = $1;`;
    const result = await adminQuery(query, [id]);
    return result.rows[0] || null;
  }

  async update(id, updates) {
    const fields = [];
    const values = [];
    let idx = 1;

    const columnMapping = {
      name: 'name',
      email: 'email',
      loginId: 'login_id',
      passwordHash: 'password_hash',
      status: 'status',
      role: 'role',
      lastLoginAt: 'last_login_at',
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
      UPDATE admins
      SET ${fields.join(', ')}
      WHERE id = $${idx}
      RETURNING *;
    `;

    const result = await adminQuery(query, values);
    return result.rows[0] || null;
  }

  async delete(id) {
    const query = `DELETE FROM admins WHERE id = $1 RETURNING *;`;
    const result = await adminQuery(query, [id]);
    return result.rows[0] || null;
  }

  async findAll() {
    const query = `SELECT * FROM admins ORDER BY created_at DESC;`;
    const result = await adminQuery(query);
    return result.rows;
  }
}

module.exports = new AdminRepository();
