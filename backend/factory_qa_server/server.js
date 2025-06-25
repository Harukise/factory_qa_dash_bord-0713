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
  user: '',
  password: '',
  database: 'factory_qa'
});

// resin_checksへの記録（残量チェック）
app.post('/api/resin-check', async (req, res) => {
  try {
    const { datetime, tankNumber, status, checker } = req.body;

    console.log('[🔥 resin-check 受信]', { datetime, tankNumber, status, checker });

    const [result] = await db.execute(
      `INSERT INTO resin_checks (datetime, tank_number, status, checker)
       VALUES (?, ?, ?, ?)`,
      [datetime, tankNumber, status, checker]
    );

    res.json({ success: true, id: result.insertId });
  } catch (err) {
    console.error('❌ resin-check error:', err.message);
    res.status(500).json({ error: '残量記録登録失敗' });
  }
});

// resin_checksへの記録（補充完了記録）
app.post('/api/resin-supply', async (req, res) => {
  try {
    const { datetime, tankNumber, status, checker, amount, supplier, notes } = req.body;

    console.log('[🔥 resin-supply 受信]', { datetime, tankNumber, status, checker, amount, supplier, notes });

    const [result] = await db.execute(
      `INSERT INTO resin_checks (datetime, tank_number, status, checker, amount, supplier, notes)
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [datetime, tankNumber, status, checker, amount, supplier ?? null, notes ?? null]
    );

    res.json({ success: true, id: result.insertId });
  } catch (err) {
    console.error('❌ resin-supply error:', err.message);
    res.status(500).json({ error: '補充記録登録失敗' });
  }
});

app.listen(PORT, () => {
  console.log(`✅ APIサーバーが起動しました → http://localhost:${PORT}`);
});
