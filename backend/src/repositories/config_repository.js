const { pool } = require('../db/database');

class ConfigRepository {
  async getAll() {
    const query = `SELECT * FROM app_configs ORDER BY category, key;`;
    const result = await pool.query(query);
    return result.rows;
  }

  async getByCategory(category) {
    const query = `SELECT * FROM app_configs WHERE category = $1;`;
    const result = await pool.query(query, [category]);
    return result.rows;
  }

  async upsert({ id, category, key, value, description, updatedBy }) {
    const query = `
      INSERT INTO app_configs (
        id, category, key, value, description, updated_by, updated_at
      ) VALUES (
        $1, $2, $3, $4, $5, $6, NOW()
      )
      ON CONFLICT (category, key) DO UPDATE SET
        value = EXCLUDED.value,
        description = COALESCE(EXCLUDED.description, app_configs.description),
        updated_by = EXCLUDED.updated_by,
        updated_at = NOW()
      RETURNING *;
    `;
    const values = [
      id,
      category,
      key,
      JSON.stringify(value),
      description || null,
      updatedBy || 'system',
    ];
    const result = await pool.query(query, values);
    return result.rows[0];
  }
}

module.exports = new ConfigRepository();
