const express = require('express');
const mysql = require('mysql2/promise');
const cors = require('cors');
const app = express();
const PORT = 3000;

app.use(cors());
app.use(express.json());

// MySQL接続設定（個人の環境にあわせて入力してください）
const db = mysql.createPool({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'factory_qa'
});

// resin_checksへの記録（残量チェック）
app.post('/api/resin-check', async (req, res) => {
  try {
    const { datetime, tankNumber, status, checker, lotNumber } = req.body;

    console.log('[🔥 resin-check 受信]', { datetime, tankNumber, status, checker, lotNumber });

    const [result] = await db.execute(
      `INSERT INTO resin_checks (datetime, tank_number, status, checker, lot_number)
       VALUES (?, ?, ?, ?, ?)`,
      [datetime, tankNumber, status, checker, lotNumber]
    );

    // lot_numberも返却
    const [rows] = await db.execute(
      `SELECT datetime, tank_number AS tankNumber, status, checker, lot_number AS lotNumber
       FROM resin_checks WHERE id = ?`, [result.insertId]
    );

    res.json({ success: true, record: rows[0] });
  } catch (err) {
    console.error('❌ resin-check error:', err.message);
    res.status(500).json({ error: '残量記録登録失敗' });
  }
});

// resin_checksへの記録（補充完了記録）
app.post('/api/resin-supply', async (req, res) => {
  try {
    const { datetime, tankNumber, status, checker, amount, supplier, notes, lotNumber } = req.body;

    console.log('[🔥 resin-supply 受信]', { datetime, tankNumber, status, checker, amount, supplier, notes, lotNumber });

    const [result] = await db.execute(
      `INSERT INTO resin_checks (datetime, tank_number, status, checker, amount, supplier, notes, lot_number)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
      [datetime, tankNumber, status, checker, amount, supplier ?? null, notes ?? null, lotNumber]
    );

    // lot_numberも返却
    const [rows] = await db.execute(
      `SELECT datetime, tank_number AS tankNumber, status, checker, amount, supplier, notes, lot_number AS lotNumber
       FROM resin_checks WHERE id = ?`, [result.insertId]
    );

    res.json({ success: true, record: rows[0] });
  } catch (err) {
    console.error('❌ resin-supply error:', err.message);
    res.status(500).json({ error: '補充記録登録失敗' });
  }
});

// 温度・基準管理記録
app.post('/api/temperature-record', async (req, res) => {
  try {
    const { datetime, lotNumber, setTemp, actualTemp, checker, notes } = req.body;
    const [result] = await db.execute(
      `INSERT INTO temperature_records (datetime, lot_number, set_temp, actual_temp, checker, notes)
       VALUES (?, ?, ?, ?, ?, ?)`,
      [datetime, lotNumber, setTemp, actualTemp, checker, notes ?? null]
    );
    res.json({ success: true, id: result.insertId });
  } catch (err) {
    console.error('❌ temperature-record error:', err.message);
    res.status(500).json({ error: '温度記録登録失敗' });
  }
});

// プリフォーム品質確認記録
app.post('/api/preform-check', async (req, res) => {
  try {
    const { sampleNumber, weight, shapeEval, inspector, photoPath, recommendedAction, notes, lotNumber } = req.body;
    const [result] = await db.execute(
      `INSERT INTO preform_quality_checks (sample_number, weight, shape_eval, inspector, photo_path, recommended_action, notes, lot_number)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
      [sampleNumber, weight, shapeEval, inspector, photoPath ?? null, recommendedAction ?? null, notes ?? null, lotNumber]
    );
    const [rows] = await db.execute(
      `SELECT datetime, sample_number AS sampleNumber, weight, weight_judgment AS weightJudgment, shape_eval AS shapeEval, inspector, lot_number AS lotNumber
       FROM preform_quality_checks WHERE id = ?`, [result.insertId]
    );
    res.json({ success: true, record: rows[0] });
  } catch (err) {
    console.error('❌ preform-check error:', err.message);
    res.status(500).json({ error: 'プリフォーム品質記録登録失敗' });
  }
});

// 成型工程モニタ記録
app.post('/api/molding-check', async (req, res) => {
  try {
    console.log('受信データ:', req.body);
    const { productNumber, thickness, shapeEval, inspector, recommendedAction, notes, lotNumber } = req.body;
    const [result] = await db.execute(
      `INSERT INTO molding_inspections (product_number, thickness, shape_eval, inspector, recommended_action, notes, lot_number)
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [productNumber, thickness, shapeEval, inspector, recommendedAction ?? null, notes ?? null, lotNumber]
    );
    const [rows] = await db.execute(
      `SELECT datetime, product_number AS productNumber, thickness, thickness_judgment AS thicknessJudgment, shape_eval AS shapeEval, inspector, lot_number AS lotNumber
       FROM molding_inspections WHERE id = ?`, [result.insertId]
    );
    console.log('返却レコード:', rows[0]);
    res.json({ success: true, record: rows[0] });
  } catch (err) {
    console.error('❌ molding-check error:', err.message);
    res.status(500).json({ error: '成型工程記録登録失敗' });
  }
});

// 冷却時間ログ記録
app.post('/api/cooling-log', async (req, res) => {
  try {
    // すべての値をnullガード
    const lotNumber = req.body.lotNumber ?? null;
    const startTime = req.body.startTime ?? null;
    const endTime = req.body.endTime ?? null;
    const operator = req.body.operator ?? null;
    const notes = req.body.notes ?? null;

    // 必須項目チェック
    if (!lotNumber || !startTime || !endTime || !operator) {
      return res.status(400).json({ error: '必須項目が不足しています' });
    }

    const [result] = await db.execute(
      `INSERT INTO cooling_records (lot_number, start_time, end_time, operator, notes)
       VALUES (?, ?, ?, ?, ?)`,
      [lotNumber, startTime, endTime, operator, notes]
    );

    // 100ms待ってからSELECT
    await new Promise(resolve => setTimeout(resolve, 100));

    const [rows] = await db.execute(
      `SELECT datetime, lot_number AS lotNumber, start_time AS startTime, end_time AS endTime, cooling_time_minutes AS coolingTimeMinutes, judgment, operator, notes
       FROM cooling_records WHERE id = ?`, [result.insertId]
    );
    console.log('返却レコード:', rows[0]);
    res.json({ success: true, record: rows[0] });
  } catch (err) {
    console.error('❌ cooling-log error:', err.message);
    res.status(500).json({ error: '冷却時間記録登録失敗' });
  }
});

// 検査工程記録
app.post('/api/final-inspection', async (req, res) => {
  try {
    const { inspectionId, visualCheck, dimensionCheck, pressureCheck, inspector, photoPath, recommendedAction, notes, lotNumber } = req.body;
    const [result] = await db.execute(
      `INSERT INTO final_inspections (inspection_id, visual_check, dimension_check, pressure_check, inspector, photo_path, recommended_action, notes, lot_number)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [inspectionId, visualCheck, dimensionCheck, pressureCheck, inspector, photoPath ?? null, recommendedAction ?? null, notes ?? null, lotNumber]
    );
    const [rows] = await db.execute(
      `SELECT datetime, inspection_id AS inspectionId, visual_check AS visualCheck, dimension_check AS dimensionCheck, pressure_check AS pressureCheck, overall_judgment AS overallJudgment, inspector, notes, lot_number AS lotNumber
       FROM final_inspections WHERE id = ?`, [result.insertId]
    );
    res.json({ success: true, record: rows[0] });
  } catch (err) {
    console.error('❌ final-inspection error:', err.message);
    res.status(500).json({ error: '検査工程記録登録失敗' });
  }
});

// プリフォーム品質確認の全件取得
app.get('/api/preform-checks', async (req, res) => {
  try {
    const [rows] = await db.execute(
      `SELECT datetime, sample_number AS sampleNumber, weight, weight_judgment AS weightJudgment, shape_eval AS shapeEval, inspector, notes
       FROM preform_quality_checks
       ORDER BY datetime DESC LIMIT 5`
    );
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: 'データ取得失敗' });
  }
});

app.listen(PORT, () => {
  console.log(`✅ APIサーバーが起動しました → http://localhost:${PORT}`);
});
