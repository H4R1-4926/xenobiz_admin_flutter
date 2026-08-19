const { pool } = require('../db/database');

class FeatureFlagRepository {
  async findAll() {
    const query = `SELECT * FROM feature_flags ORDER BY name;`;
    const result = await pool.query(query);
    return result.rows;
  }

  async findByKey(key) {
    const query = `SELECT * FROM feature_flags WHERE key = $1;`;
    const result = await pool.query(query, [key]);
    return result.rows[0] || null;
  }

  async upsert({ id, key, name, description, isEnabled = false, environment = 'production', updatedBy }) {
    const query = `
      INSERT INTO feature_flags (
        id, key, name, description, is_enabled, environment, updated_by, updated_at
      ) VALUES (
        $1, $2, $3, $4, $5, $6, $7, NOW()
      )
      ON CONFLICT (key) DO UPDATE SET
        name = EXCLUDED.name,
        description = COALESCE(EXCLUDED.description, feature_flags.description),
        is_enabled = EXCLUDED.is_enabled,
        environment = EXCLUDED.environment,
        updated_by = EXCLUDED.updated_by,
        updated_at = NOW()
      RETURNING *;
    `;
    const values = [
      id,
      key,
      name,
      description || null,
      isEnabled,
      environment,
      updatedBy || 'system',
    ];
    const result = await pool.query(query, values);
    return result.rows[0];
  }

  async toggle(key, updatedBy) {
    const flag = await this.findByKey(key);
    if (!flag) return null;
    const query = `
      UPDATE feature_flags
      SET is_enabled = NOT is_enabled, updated_by = $1, updated_at = NOW()
      WHERE key = $2
      RETURNING *;
    `;
    const result = await pool.query(query, [updatedBy || 'admin', key]);
    return result.rows[0];
  }
}

module.exports = new FeatureFlagRepository();
